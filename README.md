# 📋 Protobuf Contracts

[![Go Version](https://img.shields.io/badge/Go-1.21+-blue.svg)](https://golang.org/)
[![Protobuf](https://img.shields.io/badge/Protobuf-3.0+-green.svg)](https://developers.google.com/protocol-buffers)
[![gRPC](https://img.shields.io/badge/gRPC-1.0+-orange.svg)](https://grpc.io/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

> 🚀 **Современные protobuf контракты для микросервисной архитектуры**  
> Этот репозиторий содержит готовые к использованию protobuf схемы для сервиса управления аккаунтами с поддержкой пагинации, автоматической генерацией Go кода и REST API.

## 🏗️ Структура проекта

```
contracts/
├── 📁 account/                    # Модуль управления аккаунтами
│   ├── 📄 account_model.proto     # Модели данных пользователя
│   ├── 📄 account_service.proto   # gRPC сервис аккаунтов
│   └── 📁 go/                     # Автогенерированные Go файлы
│       ├── 📄 account_model.pb.go
│       ├── 📄 account_service.pb.go
│       └── 📄 account_service_grpc.pb.go
├── 📁 pagination/                 # Модуль пагинации
│   ├── 📄 pagination.proto        # Модель пагинации
│   └── 📁 go/                     # Автогенерированные Go файлы
│       └── 📄 pagination.pb.go
├── 🐳 Dockerfile                  # Docker образ для генерации
├── 🔧 Makefile                    # Автоматизация процессов
└── 📖 README.md                   # Документация
```

## ✨ Особенности

- 🔄 **Автоматическая генерация** Go кода из protobuf схем
- 🌐 **REST API** через gRPC Gateway
- 📱 **gRPC** для высокопроизводительной коммуникации
- 📊 **Встроенная пагинация** для больших списков
- 🐳 **Docker** для изолированной генерации
- 🚀 **Makefile** для простой автоматизации
- 📝 **Валидация** protobuf файлов

## 🚀 Быстрый старт

### Предварительные требования

- [Docker](https://docs.docker.com/get-docker/) (установлен и запущен)
- [Make](https://www.gnu.org/software/make/) (обычно предустановлен в Unix системах)
- [Git](https://git-scm.com/) для клонирования репозитория

### Установка

```bash
# Клонирование репозитория
git clone https://github.com/yuliapopova/contracts.git
cd contracts

# Генерация Go файлов
make gen

# Проверка результата
ls -la */go/
```

## 🛠️ Использование Makefile

### Основные команды

| Команда | Описание | Результат |
|---------|----------|-----------|
| `make docker-build` | Сборка Docker образа | Создание образа `proto-builder` |
| `make gen` | Генерировать Go файлы | Создание Go кода в папке `go/` |
| `make clean` | Очистить Go файлы | Удаление всех папок `go/` |

### Детальный процесс генерации

```bash
# 1. Сборка Docker образа (автоматически при выполнении gen)
make docker-build

# 2. Генерация Go файлов
make gen

# 3. Проверка результата
ls -la */go/
```

## 📊 API Endpoints

### REST API (через gRPC Gateway)

| Метод | Endpoint | Описание | Тело запроса |
|-------|----------|----------|--------------|
| `POST` | `/account/api/v1/create_user` | Создание пользователя | `CreateUser` |
| `GET` | `/account/api/v1/users/{user_id}` | Получение пользователя | - |
| `GET` | `/account/api/v1/users` | Список пользователей | `Pagination` |
| `PUT` | `/account/api/v1/users/{user_id}` | Обновление пользователя | `User` |
| `DELETE` | `/account/api/v1/users/{user_id}` | Удаление пользователя | - |

### gRPC методы

| Метод | Описание | Request | Response |
|-------|----------|---------|----------|
| `CreateUser` | Создание пользователя | `CreateUserRequest` | `google.protobuf.Empty` |
| `GetUser` | Получение пользователя | `GetUserRequest` | `GetUserResponse` |
| `GetUsers` | Список пользователей | `GetUsersRequest` | `GetUsersResponse` |
| `UpdateUser` | Обновление пользователя | `UpdateUserRequest` | `google.protobuf.Empty` |
| `DeleteUser` | Удаление пользователя | `DeleteUserRequest` | `google.protobuf.Empty` |

## 📋 Модели данных

### User Model

```protobuf
message User {
    uint64 id = 1;           // Уникальный идентификатор
    string login = 2;        // Логин пользователя
    string phone = 3;        // Номер телефона
    string first_name = 4;   // Имя
    string last_name = 5;    // Фамилия
    string middle_name = 6;  // Отчество
    string email = 7;        // Email адрес
    uint32 age = 8;         // Возраст
}
```

### CreateUser Model

```protobuf
message CreateUser {
    string login = 1;        // Логин пользователя
    string phone = 2;        // Номер телефона
    string first_name = 3;   // Имя
    string last_name = 4;    // Фамилия
    string middle_name = 5;  // Отчество
    string email = 6;        // Email адрес
    uint32 age = 7;         // Возраст
    string password = 8;     // Пароль
}
```

### Pagination Model

```protobuf
message Pagination {
    uint32 page = 1;         // Номер страницы (начиная с 1)
    uint32 limit = 2;        // Количество элементов на странице
    uint64 total = 3;        // Общее количество элементов
    uint32 total_pages = 4;  // Общее количество страниц
}
```

## 🔧 Интеграция

### Go проекты

```go
import (
    "github.com/yuliapopova/contracts/account/go"
    "github.com/yuliapopova/contracts/pagination/go"
)

// Использование моделей
user := &account.User{
    Login:     "john_doe",
    FirstName: "John",
    LastName:  "Doe",
    Email:     "john@example.com",
}

// Использование пагинации
pagination := &pagination.Pagination{
    Page:  1,
    Limit: 10,
}
```

### gRPC сервер

```go
type AccountServer struct {
    account.UnimplementedAccountServer
}

func (s *AccountServer) CreateUser(ctx context.Context, req *account.CreateUserRequest) (*emptypb.Empty, error) {
    // Ваша логика создания пользователя
    return &emptypb.Empty{}, nil
}
```

## 🧪 Валидация и тестирование

```bash
# Проверка синтаксиса proto файлов
protoc --proto_path=. --descriptor_set_out=descriptor.pb *.proto

# Проверка структуры проекта
find account pagination -name '*.proto' -exec echo "Found: {}" \;

# Валидация Docker образа
docker images | grep proto-builder
```

## 📦 Генерация для других языков

Хотя текущий Makefile настроен для Go, вы можете легко адаптировать его для других языков:

- **Python**: `protoc --python_out=. --grpc_python_out=.`
- **JavaScript**: `protoc --js_out=. --grpc-web_out=.`
- **Java**: `protoc --java_out=. --grpc_java_out=.`
- **C#**: `protoc --csharp_out=. --grpc_csharp_out=.`

## 🤝 Вклад в проект

1. 🍴 Форкните репозиторий
2. 🌿 Создайте feature branch (`git checkout -b feature/amazing-feature`)
3. 💾 Зафиксируйте изменения (`git commit -m 'Add amazing feature'`)
4. 📤 Отправьте в branch (`git push origin feature/amazing-feature`)
5. 🔀 Создайте Pull Request

## 📄 Лицензия

Этот проект распространяется под лицензией MIT. См. файл [LICENSE](LICENSE) для получения дополнительной информации.

## 🆘 Поддержка

Если у вас есть вопросы или проблемы:

- 📧 Создайте [Issue](https://github.com/yuliapopova/contracts/issues)
- 💬 Обсудите в [Discussions](https://github.com/yuliapopova/contracts/discussions)
- 📚 Изучите [Wiki](https://github.com/yuliapopova/contracts/wiki)

## 🔗 Полезные ссылки

- [Protocol Buffers](https://developers.google.com/protocol-buffers) - Официальная документация
- [gRPC](https://grpc.io/) - Высокопроизводительный RPC фреймворк
- [gRPC Gateway](https://github.com/grpc-ecosystem/grpc-gateway) - REST API для gRPC
- [Buf](https://buf.build/) - Современные инструменты для protobuf

---

<div align="center">

**⭐ Не забудьте поставить звездочку репозиторию, если он вам понравился! ⭐**

</div>


