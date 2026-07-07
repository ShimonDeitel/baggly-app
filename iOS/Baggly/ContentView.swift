import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var purchases: PurchaseManager
    @State private var showingAdd = false
    @State private var showingPaywall = false
    @State private var showingSettings = false

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                List {
                    ForEach(store.entries) { entry in
                        EntryRow(entry: entry)
                            .listRowBackground(Theme.background)
                    }
                    .onDelete { offsets in
                        store.delete(at: offsets)
                    }
                }
                .scrollContentBackground(.hidden)
                .listStyle(.plain)
            }
            .navigationTitle("Baggly")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gearshape")
                    }
                    .accessibilityIdentifier("button_settings")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if store.canAddMore {
                            showingAdd = true
                        } else {
                            showingPaywall = true
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                    .accessibilityIdentifier("button_add")
                }
            }
            .sheet(isPresented: $showingAdd) {
                AddEntryView()
            }
            .sheet(isPresented: $showingPaywall) {
                PaywallView()
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
            .tint(Theme.accent)
        }
    }
}

struct EntryRow: View {
    let entry: LogEntry

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.primaryText)
                    .font(Theme.headlineFont)
                    .foregroundStyle(Theme.text)
                if !entry.secondaryText.isEmpty {
                    Text(entry.secondaryText)
                        .font(Theme.captionFont)
                        .foregroundStyle(Theme.text.opacity(0.7))
                }
                HStack {
                    if !entry.tag.isEmpty {
                        Text(entry.tag)
                            .font(Theme.captionFont)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(Theme.accent.opacity(0.2))
                            .foregroundStyle(Theme.accent)
                            .clipShape(Capsule())
                    }
                    Text(entry.date, style: .date)
                        .font(Theme.captionFont)
                        .foregroundStyle(Theme.text.opacity(0.5))
                }
            }
            Spacer()
            VStack(alignment: .trailing) {
                if let num = entry.numericValue {
                    Text(String(format: "%.1f", num))
                        .font(Theme.bodyFont.bold())
                        .foregroundStyle(Theme.accent2)
                }
                    if entry.isDone {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(Theme.accent)
                    }
            }
        }
        .padding(.vertical, 6)
    }
}

struct AddEntryView: View {
    @EnvironmentObject var store: Store
    @Environment(\.dismiss) var dismiss

    @State private var primaryText: String = ""
    @State private var secondaryText: String = ""
    @State private var numericText: String = ""
    @State private var tag: String = ""
    @State private var date: Date = Date()
    @State private var isDone: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        TextField("Item", text: $primaryText)
                            .textFieldStyle(.roundedBorder)
                            .accessibilityIdentifier("field_primary")
                        TextField("Notes", text: $secondaryText, axis: .vertical)
                            .textFieldStyle(.roundedBorder)
                            .accessibilityIdentifier("field_secondary")
                        
                    TextField("Quantity", text: $numericText)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(.roundedBorder)
                        .accessibilityIdentifier("field_numeric")
                        
                    TextField("Category", text: $tag)
                        .textFieldStyle(.roundedBorder)
                        .accessibilityIdentifier("field_tag")
                        DatePicker("Date", selection: $date, displayedComponents: .date)
                            .accessibilityIdentifier("field_date")
                        
                    Toggle("Done", isOn: $isDone)
                        .accessibilityIdentifier("field_done")
                    }
                    .padding()
                }
                .onTapGesture {
                    hideKeyboard()
                }
            }
            .navigationTitle("Add Item")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .accessibilityIdentifier("button_cancel")
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let entry = LogEntry(
                            date: date,
                            primaryText: primaryText,
                            secondaryText: secondaryText,
                            numericValue: Double(numericText), isDone: isDone
                        )
                        store.add(entry)
                        dismiss()
                    }
                    .disabled(primaryText.trimmingCharacters(in: .whitespaces).isEmpty)
                    .accessibilityIdentifier("button_save")
                }
            }
            .tint(Theme.accent)
        }
    }
}

#if canImport(UIKit)
import UIKit
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
