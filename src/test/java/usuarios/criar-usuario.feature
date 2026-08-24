Feature: Registrar usuario
  Como administrador del sistema
  Quiero poder registrar un nuevo usuario con datos válidos
  Para poder administrar la base de datos de usuarios

  Background:
    * url baseUrl
    * def usuarioSchema = read('classpath:usuarios/schemas/usuario-schema.js')

  @smoke @positivo
  Scenario: Registrar un usuario con datos válidos
    * def nuevoUsuario = call read('classpath:usuarios/utils/gerar-usuario.js')
    Given path '/usuarios'
    And request nuevoUsuario
    When method POST
    Then status 201
    And match response == { message: '#string', _id: '#string' }
    And def usuarioId = response._id

    Given path '/usuarios', usuarioId
    When method GET
    Then status 200
    And match response.nome == nuevoUsuario.nome
    And match response.email == nuevoUsuario.email
    And match response.administrador == nuevoUsuario.administrador

  @positivo
  Scenario Outline: Registrar usuarios con distintos valores válidos del campo administrador
    * def nuevoUsuario = call read('classpath:usuarios/utils/gerar-usuario.js') { administrador: '<administrador>' }
    Given path '/usuarios'
    And request nuevoUsuario
    When method POST
    Then status 201
    And match response.message == 'Cadastro realizado com sucesso'

    Examples:
      | administrador |
      | true           |
      | false          |

  @negativo
  Scenario: No se puede registrar un usuario con un email ya existente
    * def usuarioBase = call read('classpath:usuarios/utils/gerar-usuario.js')
    Given path '/usuarios'
    And request usuarioBase
    When method POST
    Then status 201

    Given path '/usuarios'
    And request usuarioBase
    When method POST
    Then status 400
    And match response.message == 'Este email já está sendo usado'

  @negativo
  Scenario: No se puede registrar un usuario si falta el campo "nome"
    * def usuarioBase = call read('classpath:usuarios/utils/gerar-usuario.js')
    * remove usuarioBase.nome
    Given path '/usuarios'
    And request usuarioBase
    When method POST
    Then status 400
    And match response.nome == 'nome é obrigatório'

  @negativo
  Scenario: No se puede registrar un usuario si falta el campo "email"
    * def usuarioBase = call read('classpath:usuarios/utils/gerar-usuario.js')
    * remove usuarioBase.email
    Given path '/usuarios'
    And request usuarioBase
    When method POST
    Then status 400
    And match response.email == 'email é obrigatório'

  @negativo
  Scenario: No se puede registrar un usuario si falta el campo "password"
    * def usuarioBase = call read('classpath:usuarios/utils/gerar-usuario.js')
    * remove usuarioBase.password
    Given path '/usuarios'
    And request usuarioBase
    When method POST
    Then status 400
    And match response.password == 'password é obrigatório'

  @negativo
  Scenario: No se puede registrar un usuario si falta el campo "administrador"
    * def usuarioBase = call read('classpath:usuarios/utils/gerar-usuario.js')
    * remove usuarioBase.administrador
    Given path '/usuarios'
    And request usuarioBase
    When method POST
    Then status 400
    And match response.administrador == 'administrador é obrigatório'

  @negativo
  Scenario: No se puede registrar un usuario con un email con formato inválido
    * def nuevoUsuario = call read('classpath:usuarios/utils/gerar-usuario.js') { email: 'correo-invalido-sin-arroba' }
    Given path '/usuarios'
    And request nuevoUsuario
    When method POST
    Then status 400
