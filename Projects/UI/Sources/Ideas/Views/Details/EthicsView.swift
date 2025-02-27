import Core
import Networking
import SwiftUI

/// A view that displays ethics and risk information for an idea
struct EthicsView: View {
    let ethics: Ethics?
    
    var body: some View {
        VStack(alignment: .leading, spacingSize: .md) {
            SectionHeaderView(title: "Ethics & Risk Assessment")
            
            if let ethics = ethics {
                // Risks
                if let risks = ethics.risks, !risks.isEmpty {
                    risksView(risks)
                }
                
                // Mitigations
                if let mitigations = ethics.mitigations, !mitigations.isEmpty {
                    mitigationsView(mitigations)
                }
            } else {
                Text("No ethics information available")
                    .font(.body)
                    .foregroundStyle(Color.secondary)
            }
        }
        .padding(.vertical, .md)
    }
    
    private func risksView(_ risks: [Risk]) -> some View {
        VStack(alignment: .leading, spacingSize: .sm) {
            Text("Potential Risks")
                .font(.subheadline)
                .fontWeight(.medium)
            
            ForEach(risks.indices, id: \.self) { index in
                let risk = risks[index]
                riskCard(risk)
            }
        }
    }
    
    private func riskCard(_ risk: Risk) -> some View {
        VStack(alignment: .leading, spacingSize: .sm) {
            HStack {
                if let type = risk.type {
                    Text(type)
                        .font(.callout)
                        .fontWeight(.semibold)
                }
                
                Spacer()
                
                if let severity = risk.severity {
                    Text(severity)
                        .font(.caption)
                        .padding(.horizontal, .sm)
                        .padding(.vertical, .xs)
                        .background(
                            Capsule()
                                .fill(severityColor(severity).opacity(0.2))
                        )
                        .foregroundStyle(severityColor(severity))
                }
            }
            
            if let description = risk.description {
                Text(description)
                    .font(.body)
                    .foregroundStyle(Color.secondary)
            }
        }
        .padding(.all, .md)
        .background(
            RoundedRectangle(cornerRadius: Size.md.rawValue)
                .fill(Color.secondary.opacity(0.1))
        )
        .padding(.bottom, .sm)
    }
    
    private func mitigationsView(_ mitigations: [String]) -> some View {
        VStack(alignment: .leading, spacingSize: .sm) {
            Text("Risk Mitigation Strategies")
                .font(.subheadline)
                .fontWeight(.medium)
            
            ForEach(mitigations, id: \.self) { mitigation in
                HStack(alignment: .top, spacingSize: .sm) {
                    Image(systemName: "shield.checkered")
                        .foregroundStyle(Color.green)
                    
                    Text(mitigation)
                        .font(.callout)
                }
                .padding(.vertical, .xs)
            }
        }
        .padding(.all, .md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: Size.md.rawValue)
                .fill(Color.secondary.opacity(0.1))
        )
    }
    
    private func severityColor(_ severity: String) -> Color {
        let lowercaseSeverity = severity.lowercased()
        
        if lowercaseSeverity.contains("high") {
            return .red
        } else if lowercaseSeverity.contains("medium") {
            return .orange
        } else {
            return .green
        }
    }
}

#Preview {
    EthicsView(ethics: Ethics(
        risks: [
            Risk(
                type: "Data Privacy",
                description: "Collection and storage of user personal information poses privacy risks",
                severity: "High"
            ),
            Risk(
                type: "Algorithmic Bias",
                description: "AI recommendations may exhibit unintended bias",
                severity: "Medium"
            ),
            Risk(
                type: "Security",
                description: "Payment processing systems may be vulnerable to attacks",
                severity: "High"
            )
        ],
        mitigations: [
            "Implement end-to-end encryption for all user data",
            "Regular third-party security audits",
            "Diverse training data for AI algorithms",
            "Clear opt-out options for data collection"
        ]
    ))
    .padding()
} 
