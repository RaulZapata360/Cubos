package com.conteo.camiones.presentation.navigation

import androidx.compose.runtime.Composable
import androidx.navigation.NavHostController
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import com.conteo.camiones.presentation.screens.login.LoginScreen

sealed class Screen(val route: String) {
    object Login : Screen("login")
    object SiteSelector : Screen("site_selector")
    object Counter : Screen("counter")
    object BossDashboard : Screen("boss_dashboard")
}

@Composable
fun NavGraph(
    navController: NavHostController = rememberNavController(),
    startDestination: String = Screen.Login.route
) {
    NavHost(
        navController = navController,
        startDestination = startDestination
    ) {
        composable(Screen.Login.route) {
            LoginScreen(navController = navController)
        }
        
        // TODO: Add other screens as they are implemented
        // composable(Screen.SiteSelector.route) { SiteSelectorScreen(navController) }
        // composable(Screen.Counter.route) { CounterScreen(navController) }
        // composable(Screen.BossDashboard.route) { BossDashboardScreen(navController) }
    }
}
