import { useEffect, useState } from "react";
import PaperCard from "../component/paperCard";
import { useSelector } from "react-redux";
import { BACKEND_URL } from "../const/default";
import BuyModal from "../modals/buyModal";

function CartPage() {
    const user = useSelector((state) => state.user);
    const [items, setItems] = useState([]);
    const [isBuyModalVisible, setBuyModalVisible] = useState(false);
    const [selectedArticles, setSelectedArticles] = useState([]);
    const [isAllChecked, setAllChecked] = useState(false); // State for "Check All"
    const [articleUseCoupons, setArticleUseCoupons] = useState([]);
    const sa = useSelector(state => state.sa.list);
    const addSelectedArticles = async () => {
        const cartID = user.cartId;
        // Add logic for adding articles to the cart if needed
    };

    const removeSelectedArticles = async () => {
        const cartID = user.cartId;
        // Add logic for removing articles from the cart if needed
    };

    const handleCheckboxChange = (e, article) => {
        const { checked } = e.target;

        if (checked) {
            setSelectedArticles((prev) => [...prev, article]);
        } else {
            setSelectedArticles((prev) => prev.filter((item) => item.id !== article.id));
        }
    };
    // console.log(articleUseCoupons);
    const handleCheckAll = () => {
        if (isAllChecked) {
            // Uncheck all
            setSelectedArticles([]);
        } else {
            // Check all
            setSelectedArticles(items);
        }
        setAllChecked(!isAllChecked); // Toggle "Check All" state
    };

    const getCart = async () => {
        try {
            if (user.id === undefined) return;
            const response = await fetch(
                `${BACKEND_URL}/cart/getall/reader/${user.id}`,
                {
                    method: "GET",
                }
            );

            if (!response.ok) {
                throw new Error(`HTTP error! Status: ${response.status}`);
            }
            const data = await response.json();
            const info = data.data;
            // sa.filter(saItem =>
            //     data?.data?.some(dataItem => dataItem.id === saItem.id)
            // );
            console.log(data.data);
            setItems(info?.map((item) => { return { ...item, isDeleted: false } }));
            console.log(data);
        } catch (error) {
            console.error("Error fetching cart:", error.message);
        }
    };
    useEffect(() => {
        if (user.id)
            getCart();
    }, [user]);

    return (
        <>
            <div className="w-full">
                {items?.length ? <div className="flex justify-between items-center mb-4">
                    {/* "Check All" Button */}
                    <button
                        onClick={handleCheckAll}
                        className={`bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-5 rounded ${isAllChecked ? "bg-red-500" : "bg-blue-500"
                            }`}
                    >
                        {isAllChecked ? "Uncheck All" : "Check All"}
                    </button>
                </div> : <></>}

                <div className="flex flex-col space-y-4">
                    {items?.length > 0 ? (
                        items.map((item, index) => (
                            <div
                                key={`cartItem-${index}`}
                                className={`${item.isDeleted ? 'hidden' : ''} flex items-center justify-between p-4 border bg-white w-full`}
                            >
                                {/* Checkbox */}
                                <div className="flex items-center">
                                    <input
                                        type="checkbox"
                                        className="w-5 h-5 border-gray-300 rounded focus:ring-blue-500 focus:ring-2"
                                        checked={selectedArticles.some(
                                            (selected) => selected.id === item.id
                                        )}
                                        onChange={(e) => handleCheckboxChange(e, item)} // Pass `item` to track the article
                                    />
                                </div>

                                {/* Article Information */}
                                <div className="flex w-11/12">
                                    <PaperCard
                                        data={item}
                                        classList="my-2"
                                        type="cart"
                                        setShowBuyModal={setBuyModalVisible}
                                        setList={setSelectedArticles}
                                        removeFC={() => setItems(items.map((item_) => {
                                            if (item_.id === item.id)
                                                return { ...item, isDeleted: true }
                                            return item_
                                        }))}
                                    />
                                </div>
                            </div>
                        ))
                    ) : (
                        <p className="text-gray-500 text-center">No items in cart</p>
                    )}
                </div>

                {/* Footer */}
                <div className="text-xl font-bold flex flex-row justify-center px-4 mt-6">
                    {/* Total can be dynamically calculated */}
                </div>
            </div>
            {selectedArticles?.length ? <button
                onClick={() => setBuyModalVisible(true)}
                className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-5 rounded mt-4"
            >
                Buy
            </button> : <></>}
            {/* Modal */}
            <BuyModal
                items={selectedArticles} // Pass selected articles to the modal
                show={isBuyModalVisible}
                setShow={setBuyModalVisible}
                handleClose={() => setBuyModalVisible(false)}
                selectedArticles={selectedArticles}
                setSelectedArticles={setSelectedArticles}
                articleUseCoupons={articleUseCoupons}
                setArticleUseCoupons={setArticleUseCoupons}
            />
        </>
    );
}

export default CartPage;
