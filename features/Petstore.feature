#language: ru

@all 
Функционал: Тестирование REST-сервиса http://petstore.swagger.io

  @pet @find_by_status
  Структура сценария: Проверка функционала "получение списка животных по статусу"
    Допустим отправляем "GET" запрос по адресу "https://petstore.swagger.io/v2/pet/" с параметром "<Параметр>"
    Тогда получаем ответ и проверяем что код ответа равен "<Код>"
    Тогда в теле ответа "<Ответ>"

    Примеры:
    |         Параметр              | Код |    Ответ   |
    | findByStatus?status=available | 200 | valid_json |
    | findByStatus?status=pending   | 200 | valid_json |
    | findByStatus?status=sold      | 200 | valid_json |
    | findByStatus?status=wrong     | 400 |   none     |

  @pet @create_pet
  Структура сценария: Проверка функционала "создание животного"
    Допустим создали новое животное со статусом "<Статус>"
    Допустим отправляем "POST" запрос по адресу "https://petstore.swagger.io/v2/pet/" с параметром ""
    Тогда получаем ответ и проверяем что код ответа равен "<Код>"
    Тогда в теле ответа "<Ответ>"
    И в ответе пришло созданное животное
    Допустим отправляем "GET" запрос по адресу "https://petstore.swagger.io/v2/pet/" с параметром "%$PET_ID%"
    Тогда получаем ответ и проверяем что код ответа равен "<Код>"
    Тогда в теле ответа "<Ответ>"
    И в ответе пришло созданное животное

    Примеры:
    |   Статус   | Код |    Ответ   |
    |  available | 200 | valid_json |
    |  pending   | 200 | valid_json |
    |  sold      | 200 | valid_json |

  @order @create_order
  Сценарий: Проверка функционала "создание заказа на животное"
    Допустим создали новый заказ
    Допустим отправляем "POST" запрос по адресу "https://petstore.swagger.io/v2/store/order/" с параметром ""
    Тогда получаем ответ и проверяем что код ответа равен "200"
    Тогда в теле ответа "valid_json"
    И в ответе пришел созданный заказ
    Допустим отправляем "GET" запрос по адресу "https://petstore.swagger.io/v2/store/order/" с параметром "%$ORDER_ID%"
    Тогда получаем ответ и проверяем что код ответа равен "200"
    Тогда в теле ответа "valid_json"
    И в ответе пришел созданный заказ

  @pet @update_pet
  Структура сценария: Проверка функционала "обновление информации по животному"
    Допустим создали новое животное со статусом "<Статус>"
    Допустим отправляем "POST" запрос по адресу "https://petstore.swagger.io/v2/pet/" с параметром ""
    Тогда получаем ответ и проверяем что код ответа равен "<Код>"
    Тогда в теле ответа "<Ответ>"
    И в ответе пришло созданное животное
    Допустим обновили данные по животному
    Допустим отправляем "POST" запрос по адресу "https://petstore.swagger.io/v2/pet/" с параметром "%$PET_ID%"
    Тогда получаем ответ и проверяем что код ответа равен "<Код>"
    Тогда в теле ответа "<Ответ>"
    И в ответе пришло обновленное животное

    Примеры:
    |   Статус   | Код |    Ответ   |
    |  available | 200 | valid_json |
    |  pending   | 200 | valid_json |
    |  sold      | 200 | valid_json |

  @delete_pet
  Структура сценария: Проверка функционала "удаление животного"
    Допустим создали новое животное со статусом "<Статус>"
    Допустим отправляем "POST" запрос по адресу "https://petstore.swagger.io/v2/pet/" с параметром ""
    Тогда получаем ответ и проверяем что код ответа равен "<Код>"
    Тогда в теле ответа "<Ответ>"
    И в ответе пришло созданное животное
    Допустим отправляем "DELETE" запрос по адресу "https://petstore.swagger.io/v2/pet/" с параметром "%$PET_ID%"
    Тогда получаем ответ и проверяем что код ответа равен "<Код>"
    Тогда в теле ответа "<Ответ>"
    Допустим отправляем "GET" запрос по адресу "https://petstore.swagger.io/v2/pet/" с параметром "%$PET_ID%"
    Тогда получаем ответ и проверяем что код ответа равен "404"


    Примеры:
    |   Статус   | Код |    Ответ   |
    |  available | 200 | valid_json |
    |  pending   | 200 | valid_json |
    |  sold      | 200 | valid_json |

  @order @delete_order
  Сценарий: Проверка функционала "удаление заказа на животное"
    Допустим создали новый заказ
    Допустим отправляем "POST" запрос по адресу "https://petstore.swagger.io/v2/store/order/" с параметром ""
    Тогда получаем ответ и проверяем что код ответа равен "200"
    Тогда в теле ответа "valid_json"
    И в ответе пришел созданный заказ
    Допустим отправляем "DELETE" запрос по адресу "https://petstore.swagger.io/v2/store/order/" с параметром "%$ORDER_ID%"
    Тогда получаем ответ и проверяем что код ответа равен "200"
    Тогда в теле ответа "valid_json"
    Допустим отправляем "GET" запрос по адресу "https://petstore.swagger.io/v2/store/order/" с параметром "%$ORDER_ID%"
    Тогда получаем ответ и проверяем что код ответа равен "404"
    Тогда в теле ответа "valid_json"