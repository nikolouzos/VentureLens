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
                    Button("Reset Filters", role: .destructive) {
                        viewModel.resetFilters()
                    }
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Apply") {
                        viewModel.applyFilters()
                        dismiss()
                    }
                }
            }
            .presentationDetents([.medium])
        }
    }
}
