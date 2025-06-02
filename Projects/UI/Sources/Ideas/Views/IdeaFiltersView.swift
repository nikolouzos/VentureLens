import SwiftUI

public struct IdeaFiltersView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: IdeaFiltersViewModel

    public init(viewModel: IdeaFiltersViewModel) {
        _viewModel = .init(wrappedValue: viewModel)
    }

    public var body: some View {
        NavigationView {
            Form {
                Section("Search") {
                    TextField("Search ideas...", text: $viewModel.query)
                }

                Section("Category") {
                    Picker("Category", selection: $viewModel.category) {
                        Text("All Categories")
                            .tag("")
                        ForEach(viewModel.availableCategories, id: \.self) { category in
                            Text(category)
                                .tag(category)
                        }
                    }
                }

                Section("Date Range") {
                    DatePicker(
                        "From",
                        selection: $viewModel.createdAfterDate,
                        in: viewModel.fromDateRange,
                        displayedComponents: [.date]
                    )

                    DatePicker(
                        "To",
                        selection: $viewModel.createdBeforeDate,
                        in: viewModel.toDateRange,
                        displayedComponents: [.date]
                    )
                }

                Section {
                    Button(
                        "Reset Filters",
                        action: viewModel.resetFilters
                    )
                    .buttonStyle(
                        TextButtonStyle(tintColor: .themePrimary)
                    )
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .buttonStyle(TextButtonStyle())
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Apply") {
                        viewModel.applyFilters()
                        dismiss()
                    }
                    .buttonStyle(TextButtonStyle())
                }
            }
            .presentationDetents(
                UIDevice.current.userInterfaceIdiom == .phone
                    ? [.medium]
                    : [.large]
            )
        }
    }
}

#Preview {
    IdeaFiltersView(
        viewModel: IdeaFiltersViewModel(
            currentRequest: .init(
                requestType: .filters(
                    query: nil,
                    category: nil,
                    createdBefore: nil,
                    createdAfter: nil
                )
            ),
            filters: .init(
                minDate: .distantPast,
                maxDate: .distantFuture,
                categories: ["Test"]
            ),
            onApplyFilters: { _, _, _, _ in }
        )
    )
}
