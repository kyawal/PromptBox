//
//  ContentView.swift
//  PromptBox
//
//  Created by Dhiraj Kyawal on 08/02/25.
//

import SwiftUI

// MARK: - Title Bar View
struct TitleBarView: View {
    let onAddTap: () -> Void
    let onSortTap: () -> Void
    let sortNewestFirst: Bool
    
    var body: some View {
        HStack(spacing: 8) {
            VStack(alignment: .leading, spacing: 2) {
                Image("TitleLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 24)
                    .colorMultiply(Color(NSColor.labelColor))
                
                Text("Click on a prompt to copy it")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Button(action: onSortTap) {
                Image(systemName: "arrow.up.arrow.down")
                    .font(.system(size: 12))
                    .foregroundColor(.primary)
                    .frame(height: 28)
                    .padding(.horizontal, 8)
                    .background(Color.primary.opacity(0.1))
                    .cornerRadius(6)
            }
            .buttonStyle(PlainButtonStyle())
            
            Button(action: onAddTap) {
                HStack(spacing: 4) {
                    Image(systemName: "plus")
                    Text("Add")
                        .font(.body)
                }
                .foregroundColor(Color(NSColor.textBackgroundColor))
                .frame(height: 28)
                .padding(.horizontal, 8)
                .background(Color(NSColor.controlTextColor))
                .cornerRadius(6)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding()
        .background(Color(NSColor.windowBackgroundColor))
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color.primary.opacity(0.1)),
            alignment: .bottom
        )
    }
}

// MARK: - Prompt Content View
struct PromptContentView: View {
    let title: String
    let content: String
    let isHovered: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.headline)
                    .lineLimit(2)
                Spacer()
            }
            Text(content)
                .font(.body)
                .foregroundColor(.secondary)
                .lineLimit(2)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.primary.opacity(isHovered ? 0.1 : 0.05))
        )
    }
}

// MARK: - Copied Overlay View
struct CopiedOverlayView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.primary.opacity(0.1))
                .transition(.opacity)
            
            Text("Copied!")
                .foregroundColor(Color(NSColor.textBackgroundColor))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(Color(NSColor.labelColor))
                )
        }
    }
}

// MARK: - Action Buttons View
struct ActionButtonsView: View {
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 6) {
            Button(action: onEdit) {
                Image(systemName: "square.and.pencil")
                    .font(.system(size: 12))
                    .foregroundColor(.primary)
                    .padding(6)
                    .background(Color.primary.opacity(0.1))
                    .cornerRadius(4)
            }
            .buttonStyle(PlainButtonStyle())
            
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .font(.system(size: 12))
                    .foregroundColor(.red)
                    .padding(6)
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(4)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(8)
    }
}

// MARK: - Delete Confirmation Sheet View
struct DeleteConfirmationView: View {
    @Binding var isPresented: Bool
    let title: String
    let onDelete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Delete Prompt")
                .font(.title2)
                .padding(.bottom, 8)
            
            Text("Are you sure you want to delete \"\(title)\" ?")
                .font(.body)
                .foregroundColor(.secondary)
            
            HStack(spacing: 8) {
                Spacer()
                Button(action: {
                    isPresented = false
                }) {
                    Text("Cancel")
                        .font(.body)
                        .foregroundColor(Color(NSColor.controlTextColor))
                        .frame(height: 28)
                        .padding(.horizontal, 8)
                        .background(Color(NSColor.controlBackgroundColor))
                        .cornerRadius(6)
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: {
                    onDelete()
                    isPresented = false
                }) {
                    Text("Delete")
                        .font(.body)
                        .foregroundColor(Color(NSColor.textBackgroundColor))
                        .frame(height: 28)
                        .padding(.horizontal, 8)
                        .background(Color.red)
                        .cornerRadius(6)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(0)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .frame(maxWidth: 368)
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(6)
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(Color(NSColor.separatorColor), lineWidth: 1)
        )
    }
}

// MARK: - Prompt List Item View
struct PromptListItemView: View {
    let prompt: Prompt
    let onCopy: (String) -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    let onDeleteRequest: (Prompt) -> Void
    @State private var isHovered = false
    @State private var showingCopied = false
    
    var body: some View {
        Button(action: {
            onCopy(prompt.content)
            withAnimation(.easeOut(duration: 0.1)) {
                showingCopied = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation(.easeIn(duration: 0.1)) {
                    showingCopied = false
                }
            }
        }) {
            ZStack(alignment: .topTrailing) {
                PromptContentView(
                    title: prompt.title,
                    content: prompt.content,
                    isHovered: isHovered
                )
                
                if showingCopied {
                    CopiedOverlayView()
                }
                
                if isHovered {
                    ActionButtonsView(
                        onEdit: onEdit,
                        onDelete: {
                            onDeleteRequest(prompt)
                        }
                    )
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .onHover { hover in
            isHovered = hover
            if hover {
                NSCursor.pointingHand.push()
            } else {
                NSCursor.pop()
            }
        }
    }
}

// MARK: - Empty State View
struct EmptyStateView: View {
    let showingSearchResults: Bool
    let searchText: String
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 12) {
                Image(systemName: showingSearchResults ? "magnifyingglass" : "square.text.square")
                    .font(.system(size: 32))
                    .foregroundColor(.secondary)
                
                Text(showingSearchResults ? "No matches for \"\(searchText)\"" : "No prompts yet")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                if !showingSearchResults {
                    Text("Add your first prompt to get started")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .position(x: geometry.size.width/2, y: geometry.size.height/2)
        }
        .frame(height: 300)
    }
}

// MARK: - Add Prompt Sheet View
struct AddPromptView: View {
    @Binding var isPresented: Bool
    @Binding var title: String
    @Binding var content: String
    let onSave: () -> Void
    
    var body: some View {
        PromptFormView(
            isPresented: $isPresented,
            title: $title,
            content: $content,
            formTitle: "Add Prompt",
            onSave: onSave
        )
    }
}

// MARK: - Edit Prompt Sheet View
struct EditPromptView: View {
    @Binding var isPresented: Bool
    @Binding var title: String
    @Binding var content: String
    let onSave: () -> Void
    
    var body: some View {
        PromptFormView(
            isPresented: $isPresented,
            title: $title,
            content: $content,
            formTitle: "Edit Prompt",
            onSave: onSave
        )
    }
}

// MARK: - Shared Prompt Form View
private struct PromptFormView: View {
    @Binding var isPresented: Bool
    @Binding var title: String
    @Binding var content: String
    let formTitle: String
    let onSave: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text(formTitle)
                    .font(.title2)
                    .padding(.bottom, 0)
                Spacer()
            }
            
            TextField("Title", text: $title)
                .textFieldStyle(PlainTextFieldStyle())
                .font(.system(.body, design: .default))
                .padding(8)
                .frame(maxWidth: .infinity)
                .frame(height: 36)
                .background(Color(NSColor.textBackgroundColor))
                .cornerRadius(6)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color(NSColor.textColor).opacity(0.15), lineWidth: 1)
                )
            
            TextField("Enter your prompt content here...", text: $content, axis: .vertical)
                .textFieldStyle(PlainTextFieldStyle())
                .font(.system(.body, design: .default))
                .lineLimit(5...10)
                .padding(8)
                .frame(height: 100)
                .background(Color(NSColor.textBackgroundColor))
                .cornerRadius(6)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color(NSColor.textColor).opacity(0.15), lineWidth: 1)
                )
            
            HStack(spacing: 8) {
                Spacer()
                Button(action: {
                    isPresented = false
                }) {
                    Text("Cancel")
                        .font(.body)
                        .foregroundColor(Color(NSColor.controlTextColor))
                        .frame(height: 28)
                        .padding(.horizontal, 8)
                        .background(Color(NSColor.controlBackgroundColor))
                        .cornerRadius(6)
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: {
                    onSave()
                    isPresented = false
                }) {
                    Text("Save")
                        .font(.body)
                        .foregroundColor(Color(NSColor.textBackgroundColor))
                        .frame(height: 28)
                        .padding(.horizontal, 8)
                        .background(Color(NSColor.controlTextColor))
                        .cornerRadius(6)
                }
                .buttonStyle(PlainButtonStyle())
                .disabled(title.isEmpty || content.isEmpty)
            }
            .padding(0)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .frame(maxWidth: 368)
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(6)
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(Color(NSColor.separatorColor), lineWidth: 1)
        )
    }
}

// MARK: - Main Content View
struct ContentView: View {
    @StateObject private var viewModel = PromptsViewModel()
    
    @State private var isAddingPrompt = false
    @State private var showingDeleteConfirmation = false
    
    @State private var editingPrompt: Prompt?
    @State private var newPromptTitle = ""
    @State private var newPromptContent = ""
    @State private var promptToDelete: Prompt?
    
    @State private var sortNewestFirst = true
    @State private var searchText = ""
    
    private var filteredPrompts: [Prompt] {
        if searchText.isEmpty {
            return viewModel.prompts
        } else {
            return viewModel.prompts.filter { prompt in
                prompt.title.localizedCaseInsensitiveContains(searchText) ||
                prompt.content.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                TitleBarView(
                    onAddTap: { isAddingPrompt = true },
                    onSortTap: {
                        sortNewestFirst.toggle()
                        withAnimation {
                            if sortNewestFirst {
                                viewModel.prompts.sort { $0.id.uuidString > $1.id.uuidString }
                            } else {
                                viewModel.prompts.sort { $0.id.uuidString < $1.id.uuidString }
                            }
                        }
                    },
                    sortNewestFirst: sortNewestFirst
                )
                
                VStack(spacing: 16) {
                    VStack {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                            TextField("Search prompts...", text: $searchText)
                                .font(.system(.body, design: .default))
                                .textFieldStyle(PlainTextFieldStyle())
                                .foregroundColor(.primary)
                                .accentColor(.primary)
                        }
                        .padding(8)
                        .background(Color(NSColor.textBackgroundColor))
                        .cornerRadius(6)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color(NSColor.textColor).opacity(0.15), lineWidth: 1)
                        )
                    }
                    
                    ScrollView {
                        VStack(spacing: 8) {
                            if filteredPrompts.isEmpty {
                                EmptyStateView(
                                    showingSearchResults: !searchText.isEmpty,
                                    searchText: searchText
                                )
                            } else {
                                ForEach(filteredPrompts) { prompt in
                                    PromptListItemView(
                                        prompt: prompt,
                                        onCopy: { content in
                                            viewModel.copyToClipboard(content)
                                        },
                                        onEdit: {
                                            editingPrompt = prompt
                                            newPromptTitle = prompt.title
                                            newPromptContent = prompt.content
                                            isAddingPrompt = true
                                        },
                                        onDelete: {
                                            if let index = viewModel.prompts.firstIndex(where: { $0.id == prompt.id }) {
                                                viewModel.deletePrompt(at: IndexSet(integer: index))
                                            }
                                        },
                                        onDeleteRequest: { prompt in
                                            promptToDelete = prompt
                                            showingDeleteConfirmation = true
                                        }
                                    )
                                }
                            }
                        }
                    }
                } .padding(16)
            }
            
            if isAddingPrompt {
                Color.black
                    .opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
                    .animation(nil, value: isAddingPrompt)
                
                AnyView(
                    Group {
                        if editingPrompt != nil {
                            EditPromptView(
                                isPresented: $isAddingPrompt,
                                title: $newPromptTitle,
                                content: $newPromptContent,
                                onSave: {
                                    if let editingPrompt = editingPrompt,
                                       let index = viewModel.prompts.firstIndex(where: { $0.id == editingPrompt.id }) {
                                        viewModel.prompts[index].title = newPromptTitle
                                        viewModel.prompts[index].content = newPromptContent
                                        self.editingPrompt = nil
                                        newPromptTitle = ""
                                        newPromptContent = ""
                                    }
                                }
                            )
                        } else {
                            AddPromptView(
                                isPresented: $isAddingPrompt,
                                title: $newPromptTitle,
                                content: $newPromptContent,
                                onSave: {
                                    viewModel.addPrompt(title: newPromptTitle, content: newPromptContent)
                                    newPromptTitle = ""
                                    newPromptContent = ""
                                }
                            )
                        }
                    }
                )
                .animation(nil, value: isAddingPrompt)
                .onAppear {
                    if editingPrompt == nil {
                        // Clear fields when opening Add Prompt modal
                        newPromptTitle = ""
                        newPromptContent = ""
                    }
                }
            }
            
            if showingDeleteConfirmation, let prompt = promptToDelete {
                Color.black
                    .opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
                    .animation(nil, value: showingDeleteConfirmation)
                
                DeleteConfirmationView(
                    isPresented: $showingDeleteConfirmation,
                    title: prompt.title,
                    onDelete: {
                        if let index = viewModel.prompts.firstIndex(where: { $0.id == prompt.id }) {
                            viewModel.deletePrompt(at: IndexSet(integer: index))
                        }
                    }
                )
                .animation(nil, value: showingDeleteConfirmation)
            }
        }
        .background(Color(NSColor.controlBackgroundColor))
        .frame(width: 400, height: 600)
    }
}
