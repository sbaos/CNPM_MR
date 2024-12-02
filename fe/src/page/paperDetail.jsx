import { useLocation } from "react-router-dom";

function PaperDetailPage() {
    const location = useLocation();
    const queryParams = new URLSearchParams(location.search);
    const id = queryParams.get('id')
    return (<>
        <div>
        </div>
    </>);
}

export default PaperDetailPage;