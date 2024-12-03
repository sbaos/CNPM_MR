import { Link, useNavigate } from "react-router-dom";
import { adminMenu, userMenu } from "../const/menu";
import { useDispatch, useSelector } from "react-redux";
import { logout } from "../redux/userSlice";

function Header() {
    const user = useSelector(state => state.user);
    const menu = user.isLogin && user.role === 'admin' ? adminMenu : userMenu;
    const navigate = useNavigate();
    const dispatch = useDispatch();
    return (
        <header className="bg-gray-800 text-white fixed w-full z-10">
            <div className="container mx-auto px-4 flex items-center justify-between py-4">
                <div className="text-lg font-bold mr-4 ">Paper with HCMUT</div>
                <nav className="flex space-x-4">
                    {menu.map((item, index) => (
                        <Link
                            key={index}
                            to={item.path}
                            className="text-white hover:bg-gray-700 px-3 py-2 rounded-md"
                        >
                            {item.name}
                        </Link>
                    ))}
                </nav>
                {user.isLogin ?
                    <div className="flex space-x-4 items-center">
                        <div>
                            Vip: {user.vipTier}
                        </div>
                        <button onClick={() => dispatch(logout())} className="text-white hover:bg-gray-700 bg-red-500 px-3 py-2 rounded-md">Đăng xuất</button>
                    </div>
                    :
                    <button onClick={() => navigate('/login')} className="text-white hover:bg-gray-700 bg-green-500 px-3 py-2 rounded-md">Đăng nhập</button>}
            </div>
        </header >
    );
}

export default Header;
