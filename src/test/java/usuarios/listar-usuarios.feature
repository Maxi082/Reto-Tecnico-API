Feature: Listar usuarios
  Como administrador del sistema
  Quiero poder obtener la lista de todos los usuarios
  Para poder administrar la base de datos de usuarios

  Background:
    * url baseUrl
    * def usuarioSchema = read('classpath:usuarios/schemas/usuario-schema.js')

  @smoke @positivo
  Scenario: Obtener la lista completa de usuarios exitosamente
    Given path '/usuarios'
    When method GET
    Then status 200
    And match response == { quantidade: '#number', usuarios: '#array' }

  @positivo
  Scenario: Filtrar usuarios por email existente
    # Se crea un usuario para garantizar que el filtro tenga al menos un resultado
    * def nuevoUsuario = call read('classpath:usuarios/utils/gerar-usuario.js')
    Given path '/usuarios'
    And request nuevoUsuario
    When method POST
    Then status 201

    Given path '/usuarios'
    And param email = nuevoUsuario.email
    When method GET
    Then status 200
    And match response.quantidade == 1
    And match response.usuarios[0].email == nuevoUsuario.email

  @negativo
  Scenario: Filtrar por un email que no existe devuelve lista vacía
    Given path '/usuarios'
    And param email = 'no-existe-este-correo-999@gmail.com'
    When method GET
    Then status 200
    And match response.quantidade == 0
    And match response.usuarios == []
