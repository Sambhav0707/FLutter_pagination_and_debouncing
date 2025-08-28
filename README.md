# Flutter Debouncing and Pagination Example

A Flutter application demonstrating debounced search functionality and pagination using BLoC pattern with a Go backend API.

## 🚀 Features

- **Pagination**: Load players in chunks of 10 with infinite scroll
- **Debounced Search**: Search players with 1-second debounce to avoid excessive API calls
- **BLoC Pattern**: Clean architecture using flutter_bloc for state management
- **Go Backend**: RESTful API with CORS support
- **Responsive UI**: Beautiful Material Design interface
- **Error Handling**: Comprehensive error states and loading indicators

## 📱 Screenshots

- **Home Page**: Displays cricket players with pagination
- **Search Page**: Real-time search with debouncing
- **Loading States**: Smooth loading indicators
- **Error Handling**: User-friendly error messages

## 🏗️ Architecture

```
├── frontend/
│   ├── lib/
│   │   ├── core/
│   │   │   └── commons/
│   │   │       └── models/
│   │   │           └── player_model.dart
│   │   ├── features/
│   │   │   ├── home/
│   │   │   │   ├── bloc/
│   │   │   │   │   ├── home_bloc.dart
│   │   │   │   │   ├── home_event.dart
│   │   │   │   │   └── home_state.dart
│   │   │   │   ├── data/
│   │   │   │   │   └── repository/
│   │   │   │   │       └── home_repository.dart
│   │   │   │   └── presentation/
│   │   │   │       └── home_page.dart
│   │   │   └── search/
│   │   │       ├── bloc/
│   │   │       │   ├── search_bloc.dart
│   │   │       │   ├── search_event.dart
│   │   │       │   └── search_state.dart
│   │   │       ├── data/
│   │   │       │   └── repository/
│   │   │       │       └── search_repository.dart
│   │   │       └── presentation/
│   │   │           └── search_page.dart
│   │   └── main.dart
│   └── pubspec.yaml
└── Backend/
    ├── main.go
    ├── go.mod
    ├── go.sum
    ├── controllers/
    │   └── player_controller.go
    ├── models/
    │   └── player.go
    └── routes/
        └── router.go
```

## 🛠️ Tech Stack

### Frontend
- **Flutter**: 3.7.0+
- **flutter_bloc**: State management
- **http**: API communication
- **Material Design**: UI components

### Backend
- **Go**: 1.21+
- **Gorilla Mux**: HTTP router
- **CORS**: Cross-origin resource sharing

## 📋 Prerequisites

- Flutter SDK (3.7.0 or higher)
- Go (1.21 or higher)
- Dart SDK
- Android Studio / VS Code

## 🚀 Getting Started

### 1. Clone the Repository

```bash
git clone <repository-url>
cd Flutter_debouncing_and_pagination_example
```

### 2. Backend Setup

```bash
cd Backend
go mod tidy
go run main.go
```

The backend will start on `http://localhost:8081`

### 3. Frontend Setup

```bash
cd frontend
flutter pub get
flutter run
```

## 🔧 Configuration

### API URLs

**For Web Development:**
```dart
// In repository files
static const String baseUrl = 'http://localhost:8081';
```

**For Mobile Development:**
```dart
// Change to your machine's IP address
static const String baseUrl = 'http://YOUR_IP_ADDRESS:8081';
```

### Pagination Settings

**Page Size:**
```dart
// In home_bloc.dart
static const int _pageSize = 10; // ### CHANGE THIS #### - Number of players per page
```

### Debounce Duration

**Search Debounce:**
```dart
// In search_bloc.dart
await Future.delayed(const Duration(seconds: 1)); // ### CHANGE THIS #### - Debounce duration
```

## 📖 API Endpoints

### Backend API

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/players` | GET | Get all players |
| `/api/searchPlayers` | GET | Search players with query parameters |

### Query Parameters

- `q`: General search (name or role)
- `name`: Search by player name
- `role`: Search by player role

## 🎯 Features Explained

### Pagination Implementation

The pagination system loads players in chunks:

1. **Initial Load**: First 10 players
2. **Scroll Detection**: When user reaches bottom (200px from end)
3. **Load More**: Automatically loads next 10 players
4. **Loading States**: Shows loading indicator at bottom
5. **End Detection**: Stops when all players are loaded

### Debounced Search

The search functionality includes:

1. **Debouncing**: 1-second delay after user stops typing
2. **Loading States**: Immediate loading indicator
3. **Query Validation**: Checks for empty queries
4. **Error Handling**: Graceful error states
5. **Real-time Results**: Updates as user types

## 🏗️ BLoC Pattern

### Events
- `LoadInitialPlayers`: Load first page
- `LoadMorePlayers`: Load next page
- `RefreshPlayers`: Refresh all data
- `SearchQueryChanged`: Search query updated
- `ClearSearch`: Clear search results

### States
- `HomeInitial`: Initial state
- `HomeLoading`: Loading first page
- `HomeLoadingMore`: Loading more items
- `HomeLoaded`: Data loaded successfully
- `HomeError`: Error occurred
- `SearchInitial`: Search initial state
- `SearchLoading`: Search in progress
- `SearchLoaded`: Search results loaded
- `SearchError`: Search error

## 🐛 Debugging

### Debug Prints

The application includes comprehensive debug logging:

```dart
// Search Repository
debugPrint('🔍 SearchRepository: Starting search with query: "$query"');
debugPrint('🔍 SearchRepository: Making API call to: $uri');
debugPrint('🔍 SearchRepository: Found ${results.length} players');

// Search BLoC
debugPrint('🔍 SearchBloc: Debounce completed, searching for: "${event.query}"');
debugPrint('🔍 SearchBloc: Emitting SearchLoaded with ${results.length} results');
```

### Common Issues

1. **CORS Errors**: Ensure backend CORS middleware is enabled
2. **Connection Errors**: Check if backend is running on correct port
3. **API URL Issues**: Verify baseUrl in repository files
4. **Pagination Not Working**: Check scroll controller implementation

## 🧪 Testing

### Manual Testing

1. **Pagination**: Scroll to bottom to test infinite scroll
2. **Search**: Type in search box to test debouncing
3. **Error Handling**: Disconnect backend to test error states
4. **Refresh**: Pull to refresh functionality

### API Testing

```bash
# Test players endpoint
curl http://localhost:8081/api/players

# Test search endpoint
curl "http://localhost:8081/api/searchPlayers?q=virat"
```

## 📝 Customization

### Adding New Features

1. **New API Endpoints**: Add to Go backend
2. **New BLoC Events**: Extend existing BLoCs
3. **New UI Components**: Add to presentation layer
4. **New Models**: Extend player_model.dart

### Styling

- **Colors**: Modify `_getRoleColor()` method
- **Themes**: Update `main.dart` theme configuration
- **Layout**: Customize widget structure

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- BLoC library for state management
- Go team for the backend language
- Cricket data for player information

## 📞 Support

For support and questions:
- Create an issue in the repository
- Check the debug logs for error details
- Verify backend is running correctly

---

**Happy Coding! 🚀**
