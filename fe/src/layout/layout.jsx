import Body from "../component/body";
import Header from "../component/header";

function Layout({ children }) {
    return (<>
        <Header />
        <Body>
            {children}
        </Body>
    </>);
}

export default Layout;