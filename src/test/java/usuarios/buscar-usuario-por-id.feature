Feature: Buscar usuario por ID
Como administrador del sistema
Quiero poder buscar un usuario específico por su ID
Para poder verificar su información

  Background:
    * url baseUrl
    * def usuarioSchema = read('classpath:usuarios/schemas/usuario-schema.js')

  @smoke @positivo
  Scenario: Buscar un usuario existente por su ID
    # Arrange: se crea un usuario de prueba propio del escenario
    * def nuevoUsuario = call read('classpath:usuarios/utils/gerar-usuario.js')
    Given path '/usuarios'
    And request nuevoUsuario
    When method POST
    Then status 201
    * def usuarioId = response._id

    # Act & Assert
    Given path '/usuarios', usuarioId
    When method GET
    Then status 200
    # Validamos individualmente los campos y el tipo de estructura para evitar conflictos de mapeo
    And match response._id == usuarioId
    And match response.nome == nuevoUsuario.nome
    And match response.email == nuevoUsuario.email
    And match response.password == nuevoUsuario.password
    And match response.administrador == nuevoUsuario.administrador

  @negativo
  Scenario: Buscar un usuario con un ID de formato inválido devuelve error 400
    Given path '/usuarios', 'id-que-no-exi'
    When method GET
    Then status 400
    And match response.id == 'id deve ter exatamente 16 caracteres alfanuméricos'