import { useDispatch, useSelector } from "react-redux";
import { BACKEND_URL } from "../const/default";
import { useEffect, useState } from "react";
import { initSA, removeSA } from "../redux/saSlice";
import PaperCard from "../component/paperCard";
import UpdateScienceArticleModal from "../modals/updateSAModal";
import { toast } from "react-toastify";

function ManageScienceArticlePage() {
    const dispatch = useDispatch();
    const user = useSelector(state => state.user);
    const scienceArticles = useSelector(state => state.sa.list);
    const [isModalVisible, setModalVisible] = useState(false);
    const [selectedArticle, setSelectedArticle] = useState(null);
    const [action, setAction] = useState('update');
    const handleEdit = (article) => {
        setAction('update');
        setSelectedArticle(article);
        setModalVisible(true);
    };

    const handleUpdate = async () => {
        // Refresh articles or update state
        setAction('update');
        setModalVisible(false);
    };
    const getPaper = async () => {
        try {
            const response = await fetch(`${BACKEND_URL}/science_article/${user.id}`, {
                method: "GET",
            });

            if (!response.ok) {
                throw new Error(`HTTP error! Status: ${response.status}`);
            }

            const data = await response.json();
            const info = data.data.filter(item => !item.deleteAt);
            dispatch(initSA(info));
        } catch (error) {
            console.error("Error fetching papers:", error.message);
        }
    };
    const addPaper = async () => {
        setAction('add');
        setSelectedArticle({});
        setModalVisible(true);
    };
    const deletePaper = async (id) => {
        const wantToDelete = window.confirm('Bạn có chắc muốn xóa bài báo này không?');
        if (!wantToDelete) return;
        try {
            const response = await fetch(`${BACKEND_URL}/science_article/delete/${id}`, {
                method: "DELETE",
            });
            if (response.ok) {
                dispatch(removeSA(id));
                toast.success("Đã xóa thành công!");
            }
            console.log(response);
        } catch (error) {
            toast.error('Xóa thất bại');
            console.error("Error fetching papers:", error.message);
        }
    };
    useEffect(() => {
        getPaper();
    }, []);

    return (<>
        <div>
            <div className="flex flex-row justify-between mb-5">
                <div>Quản lý các bài báo</div>
                <button className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-5 rounded" onClick={() => addPaper()}>
                    Add new article
                </button>
            </div>
            <div>
                {scienceArticles.length > 0 ? (
                    scienceArticles.map((article, index) => (
                        <div key={index} className="w-full mb-4" style={{ position: 'relative' }}>
                            <button className="absolute top-0 right-0 p-2 rounded-md bg-red-500 px-3 text-white hover:bg-red-700"
                                style={{ right: '90px', top: '-10px' }}
                                onClick={() => deletePaper(article.id)}>X</button>
                            <PaperCard data={article} isManage={true} classList="px-10 py-6 mx-auto w-12/12" handleEdit={() => handleEdit(article)} />
                        </div>
                    ))
                ) : (
                    <p>No articles found.</p>
                )}
            </div>
        </div>
        <UpdateScienceArticleModal
            visible={isModalVisible}
            onClose={() => setModalVisible(false)}
            article={selectedArticle}
            onUpdate={handleUpdate}
            action={action}
        />
    </>);
}

export default ManageScienceArticlePage;