import { Route, Routes } from "react-router-dom";
import HomePage from "../page/homePage";
import PaperDetailPage from "../page/paperDetail";
import CartPage from "../page/cartPage";
import HistoryPage from "../page/historyPage";
import LoginPage from "../page/loginPage";
import RegisterPage from "../page/registerPage";
import NotFoundPage from "../page/notFoundPage";
import ManageScienceArticlePage from "../page/manageScienceArticlePage";
import { useSelector } from "react-redux";

function AppRoute() {
    const user = useSelector(state => state.user);
    return (<>
        <Routes>
            <Route path="/" element={<HomePage />} />
            <Route path="/paper/:id" element={<PaperDetailPage />} />
            <Route path="/managePaper" element={user.role === 'admin' ? <ManageScienceArticlePage /> : <NotFoundPage />} />
            <Route path="/cart" element={<CartPage />} />
            <Route path="/history" element={<HistoryPage />} />
            <Route path="/login" element={<LoginPage />} />
            <Route path="/register" element={<RegisterPage />} />
            <Route path="/manageScienceArticle" element={user.role === 'admin' ? <ManageScienceArticlePage /> : <NotFoundPage />} />
            <Route path="*" element={<NotFoundPage />} />
        </Routes>
    </>);
}

export default AppRoute;