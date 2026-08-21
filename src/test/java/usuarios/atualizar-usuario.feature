Feature: Actualizar usuario
Como administrador del sistema
Quiero poder actualizar la información de un usuario existente
Para mantener la base de datos de usuarios al día

  Background:
    * url baseUrl
    # Asegúrate de que este esquema soporte el campo '_id' generado por la API
    * def usuarioSchema = read('classpath:usuarios/schemas/usuario-schema.js')

  @smoke @positivo
  Scenario: Actualizar los datos de un usuario existente
    # 1. Crear el usuario base
    * def usuarioOriginal = call read('classpath:usuarios/utils/gerar-usuario.js')
    Given path '/usuarios'
    And request usuarioOriginal
    When method POST
    Then status 201
    * def usuarioId = response._id
    * def correoOriginal = usuarioOriginal.email

    # 2. Preparar los datos de actualización manteniendo el correo o modificándolo con control
    * def usuarioActualizado = call read('classpath:usuarios/utils/gerar-usuario.js')
    * set usuarioActualizado.nome = 'Nombre Actualizado QA'
    * set usuarioActualizado.email = correoOriginal

    # 3. Enviar la actualización al endpoint PUT
    Given path '/usuarios', usuarioId
    And request usuarioActualizado
    When method PUT
    Then status 200
    And match response.message == 'Registro alterado com sucesso'


  @positivo
  Scenario: Actualizar un usuario con un ID inexistente crea un nuevo registro
    * def usuarioNuevo = call read('classpath:usuarios/utils/gerar-usuario.js')
    Given path '/usuarios', 'id-inexistente-para-put'
    And request usuarioNuevo
    When method PUT
    Then status 201
    And match response.message == 'Cadastro realizado com sucesso'

  @negativo
  Scenario: No se puede actualizar un usuario usando el email de otro usuario ya registrado
    * def usuarioA = call read('classpath:usuarios/utils/gerar-usuario.js')
    Given path '/usuarios'
    And request usuarioA
    When method POST
    Then status 201

    * def usuarioB = call read('classpath:usuarios/utils/gerar-usuario.js')
    Given path '/usuarios'
    And request usuarioB
    When method POST
    Then status 201
    * def usuarioBId = response._id

    * set usuarioB.email = usuarioA.email
    Given path '/usuarios', usuarioBId
    And request usuarioB
    When method PUT
    Then status 400
    And match response.message == 'Este email já está sendo usado'