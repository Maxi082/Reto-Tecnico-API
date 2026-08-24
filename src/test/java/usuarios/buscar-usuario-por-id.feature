Feature: Buscar usuario por ID
Como administrador del sistema
Quiero poder buscar un usuario específico por su ID
Para poder verificar su información

  Background:
    * url baseUrl
    * def usuarioSchema = read('classpath:usuarios/schemas/usuario-schema.js')

  @smoke @positivo
  Scenario: Buscar un usuario existente por su ID
    * def nuevoUsuario = call read('classpath:usuarios/utils/gerar-usuario.js')
    Given path '/usuarios'
    And request nuevoUsuario
    When method POST
    Then status 201
    * def usuarioId = response._id

    Given path '/usuarios', usuarioId
    When method GET
    Then status 200
    And match response == usuarioSchema


  @negativo
  Scenario: Buscar un usuario con un ID de formato inválido devuelve error 400
    Given path '/usuarios', 'id-que-no-exi'
    When method GET
    Then status 400
    And match response.id == 'id deve ter exatamente 16 caracteres alfanuméricos'