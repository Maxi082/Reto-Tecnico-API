Feature: Eliminar usuario
  Como administrador del sistema
  Quiero poder eliminar un usuario del sistema
  Para mantener depurada la base de datos de usuarios

  Background:
    * url baseUrl

  @smoke @positivo
  Scenario: Eliminar un usuario existente
    * def nuevoUsuario = call read('classpath:usuarios/utils/gerar-usuario.js')
    Given path '/usuarios'
    And request nuevoUsuario
    When method POST
    Then status 201
    * def usuarioId = response._id

    Given path '/usuarios', usuarioId
    When method DELETE
    Then status 200
    And match response.message == 'Registro excluído com sucesso'

    # Verificamos que ya no exista
    Given path '/usuarios', usuarioId
    When method GET
    Then status 400
    And match response.message == 'Usuário não encontrado'

  @negativo
  Scenario: Eliminar un usuario con un ID inexistente responde con mensaje de no encontrado
    Given path '/usuarios', 'id-que-nunca-existio-999'
    When method DELETE
    Then status 200
    And match response.message == 'Nenhum registro excluído'
