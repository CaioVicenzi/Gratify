//
//  ShortcutProvider.swift
//  StreakWidgetExtension
//
//  Created by Caio Marques on 12/06/24.
//

import Foundation
import AppIntents

struct ShortcutProvider : AppShortcutsProvider {
    @AppShortcutsBuilder
    static var appShortcuts: [AppShortcut] {
        return [
            AppShortcut(
                intent: SaveGratitudeAppIntent(),
                phrases: [
                    "Salve uma gratidão no \(.applicationName)",
                    "Registre uma gratidão no \(.applicationName)",
                    "Escreva uma gratidão no \(.applicationName)",
                    "Escreva uma gratidão para mim no \(.applicationName)",
                    "Nova gratidão no \(.applicationName)"
                ],
                shortTitle: "Salvar gratidão",
                systemImageName: "pencil.tip.crop.circle.badge.plus"
            )
        ]
    }
}
