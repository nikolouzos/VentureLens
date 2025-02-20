# IdeaForge

IdeaForge is a sophisticated iOS application that empowers entrepreneurs and business analysts by providing comprehensive business intelligence and market insights. It aggregates and analyzes data from various sources (including ProductHunt, market databases, and financial reports) to generate detailed business ideas, complete with financial projections, market analysis, and strategic recommendations.

## Features

- 💡 AI-powered business idea generation and validation
- 📊 Comprehensive financial projections and analysis
- 📈 Market trend analysis and competitor insights
- 🔍 Data aggregation from multiple sources (ProductHunt, market databases)
- 📑 Detailed business strategy recommendations
- 📱 Interactive reports and visualizations
- 🔄 Real-time market data updates
- 🔒 Secure data storage with SwiftData

## Technologies

- Swift 6
- SwiftUI
- SwiftData
- Combine
- Swift Testing
- MVVM-C Architecture
- Tuist for project generation
- SwiftFormat for code quality

## Dependencies

- **Supabase** - Backend as a Service for authentication and data storage

## Requirements

- iOS 18.0+
- Xcode 16.0+
- Swift 6.0+
- Tuist 3.0+

## Environment Setup

1. Install Homebrew (if not already installed):
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

2. Install required tools:
```bash
brew install tuist
brew install swiftformat
```

3. Set up environment variables:
```bash
cp .env.example .env
```
Edit `.env` with your configuration values:
- `SUPABASE_URL`: Your Supabase project URL
- `SUPABASE_KEY`: Your Supabase API key

## Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/IdeaForge.git
cd IdeaForge
```

2. Generate Xcode project:
```bash
./scripts/load_env_and_generate.sh
```

3. Open the generated Xcode project:
```bash
open IdeaForge.xcworkspace
```

## Project Structure

```
IdeaForge/
├── Projects/
│   ├── App/
│   ├── AppResources/
│   ├── Core/
│   ├── Dependencies/
│   ├── Networking/
│   └── UI/
├── Tuist/
│   ├── Package.swift
│   └── ProjectDescriptionHelpers/
├── Scripts/
│   ├── load_env_and_generate.sh
│   └── swiftformat.sh
├── xcconfigs/
├── .env.example
├── Tuist.swift
└── Workspace.swift
```

## Architecture

IdeaForge follows the MVVM-C (Model-View-ViewModel-Coordinator) architecture pattern for clear separation of concerns and maintainable code:

- **Models**: Core data structures and business logic
- **Views**: SwiftUI views for the user interface
- **ViewModels**: Business logic and state management
- **Coordinators**: Navigation and flow control
- **Services**: API integration and data processing
- **Repositories**: Data access and caching layer

## Development

### Project Generation
The project uses Tuist for project generation and dependency management. The project must be generated using the provided script to ensure environment variables are properly loaded:

```bash
./scripts/load_env_and_generate.sh
```

This script will:
1. Load environment variables from `.env`
2. Pass them to the Tuist generate command
3. Generate the Xcode project with the correct configuration

### Scripts

- `./scripts/load_env_and_generate.sh` - Generates Xcode project with environment variables
- `./scripts/swiftformat.sh` - Formats code according to project standards
- `make test` - Runs all tests

## Testing

Run the tests using Xcode's Test Navigator (⌘+6) or using the command line:

```bash
# Run all tests
make test

# Run specific test target
xcodebuild test -scheme IdeaForge -destination 'platform=iOS Simulator,name=iPhone 15 Pro'
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

Please ensure you:
- Follow the SwiftFormat rules for code formatting
- Add tests for new features
- Update documentation as needed
- Run the test suite before submitting

## License

This project is licensed under the Elastic License v2.0 (ELv2). The ELv2 allows you to use, copy, distribute, make available, and prepare derivative works of the software, as long as you do not provide the software to others as a managed service or include it in a free competitive product. See the [LICENSE](LICENSE) file for the complete license terms.

Key points of the ELv2:
- ✅ Use and modify the code for internal purposes
- ✅ Distribute the code as part of your non-competing applications
- ❌ Use the code to create a product that competes with IdeaForge
- ❌ Provide IdeaForge as a managed service to third parties

For more information about the Elastic License v2.0, visit [Elastic License FAQ](https://www.elastic.co/licensing/elastic-license).
