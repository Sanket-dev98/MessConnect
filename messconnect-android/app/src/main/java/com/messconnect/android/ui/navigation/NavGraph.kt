package com.messconnect.android.ui.navigation

import androidx.compose.runtime.Composable
import androidx.navigation.NavHostController
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import com.messconnect.android.ui.screens.*

sealed class Screen(val route: String) {
    object RoleSelection : Screen("role_selection")
    object Login : Screen("login")
    object StudentHome : Screen("student_home")
    object MessDetail : Screen("mess_detail")
    object Khata : Screen("khata")
    object ProviderDashboard : Screen("provider_dashboard")
    object MenuManagement : Screen("menu_management")
    object AdminOverview : Screen("admin_overview")
}

@Composable
fun NavGraph(navController: NavHostController) {
    NavHost(
        navController = navController,
        startDestination = Screen.RoleSelection.route
    ) {
        composable(Screen.RoleSelection.route) {
            RoleSelectionScreen(
                onRoleSelected = { role ->
                    navController.navigate(Screen.Login.route)
                }
            )
        }
        composable(Screen.Login.route) {
            LoginScreen(
                onLoginSuccess = {
                    // Logic to navigate to correct dashboard based on role
                    navController.navigate(Screen.StudentHome.route)
                }
            )
        }
        composable(Screen.StudentHome.route) {
            StudentHomeScreen(
                onMessClick = { navController.navigate(Screen.MessDetail.route) },
                onKhataClick = { navController.navigate(Screen.Khata.route) }
            )
        }
        composable(Screen.MessDetail.route) {
            MessDetailScreen()
        }
        composable(Screen.Khata.route) {
            KhataScreen()
        }
        composable(Screen.ProviderDashboard.route) {
            ProviderDashboardScreen(
                onMenuManagementClick = { navController.navigate(Screen.MenuManagement.route) }
            )
        }
        composable(Screen.MenuManagement.route) {
            MenuManagementScreen()
        }
        composable(Screen.AdminOverview.route) {
            AdminOverviewScreen()
        }
    }
}
