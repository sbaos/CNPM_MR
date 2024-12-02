import { useEffect, useState } from "react";
import { useSelector } from "react-redux";
import { useLocation } from "react-router-dom";
import { BACKEND_URL } from "../const/default";
import { toast } from "react-toastify";
import getAllCoupon from "../utils/getAllCoupon";

function convertToNumber(priceString) {
    return parseFloat(priceString.replace('$', ''));
}
function calculateFinalPrice(item, coupons) {
    let finalPrice = convertToNumber(item.Price);  // Start with the original price of the item

    // Filter coupons that apply to the specific item
    const applicableCoupons = coupons.filter(coupon =>
        coupon.ArticleID === item.id  // Check if the coupon is for this article
    );
    console.log(applicableCoupons)
    // Apply each applicable coupon to the final price
    applicableCoupons.forEach(coupon => {
        if (coupon.DiscountUnit === '%') {
            // If it's a percentage discount, reduce the price by the percentage
            finalPrice -= finalPrice * (coupon.Discount / 100);
        } else if (coupon.DiscountUnit === '$') {
            // If it's a dollar discount, subtract the discount amount
            finalPrice -= coupon.Discount;
        }
    });

    // Ensure the final price doesn't drop below zero
    return Math.max(finalPrice, 0);
}


function PaperCard({ removeFC, type, classList, data, handleEdit, isManage = false, setShowBuyModal, setList, coupons }) {

    const location = useLocation();
    const queryParams = new URLSearchParams(location.search);
    const paperId = queryParams.get("id") || "";
    const user = useSelector(state => state.user);
    const [title, setTitle] = useState('Watermark Anything with Localized Messages');
    const [author, setAuthor] = useState('Tác giả');
    const [year, setYear] = useState('2023');
    const [journal, setJournal] = useState('Journal');
    const [subcategory, setSubcategory] = useState('Subcategory');
    const [text, setText] = useState('Watermark Anything with Localized Messages');
    const [price, setPrice] = useState('100');
    const [isDiscount, setIsDiscount] = useState(0);
    const [isDelete, setIsDelete] = useState(false);
    const [allCoupon, setAllCoupon] = useState([]);
    const [useCoupon, setUseCoupon] = useState([]);
    function convertToNumber(priceString) {
        return parseFloat(priceString.replace('$', ''));
    }

    const calPercent = () => {
        let sum = 0;
        for (let i = 0; i < useCoupon.length; i++) {
            if (useCoupon[i].DiscountUnit === "%")
                sum += convertToNumber(data.Price) * useCoupon[i].Discount / 100;
        }
        return sum;
    }
    const calDirect = () => {
        let sum = 0;
        for (let i = 0; i < useCoupon.length; i++) {
            if (useCoupon[i].DiscountUnit === "$")
                sum -= useCoupon[i].Discount;
        }
        return sum;
    }

    const addToCart = async () => {
        const cartID = user.cartId;
        try {
            const res = await fetch(`${BACKEND_URL}/cart/add/${cartID}`, {
                method: "POST",
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    ArticleID: data.id,
                }),
            });
            if (res.ok) {
                toast.success('Thêm vào giỏ hàng thành công');
            } else {
                toast.warning('Thêm vào giỏ hàng thất bại', res.statusText);
            }
            console.log(res);
        }
        catch (err) {
            toast.warning('Thêm vào giỏ hàng thất bại', err.message);
            console.log(err);
        }
    }
    const handleBuySA = async () => {
        setShowBuyModal(true);
        setList([data]);
        // const cartID = user.cartId;
        // const res = await fetch(`${BACKEND_URL}/cart/buy/${cartID}`, {
        //     method: "PUT",
        //     headers: {
        //         'Content-Type': 'application/json',
        //     },
        //     body: JSON.stringify({
        //         ArticleID: data.id,
        //     }),
        // });
        // console.log(res);
    }
    const handleRemoveFromCart = async () => {
        const cartID = user.cartId;
        const res = await fetch(`${BACKEND_URL}/cart/remove/${cartID}`, {
            method: "DELETE",
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                ArticleID: data.id,
            }),
        });
        if (res.ok) {
            removeFC();
            setIsDelete(true);
            toast.success('Xóa thành công');
        }
        console.log(res);
    }
    const OpenGithub = (githubLink) => {
        window.open(githubLink);
    }
    const getCP = async () => {
        if (!user) return;
        const data = await getAllCoupon(user.id);
        const article_coupon_data = data?.article_coupon_data;
        const payment_coupon_data = data?.payment_coupon_data;
        setAllCoupon(article_coupon_data);
    }

    function getCouponsForArticle(coupons, articleId, couponIds) {
        if (!coupons?.length) return [];
        return coupons?.filter(coupon =>
            coupon?.ArticleID === articleId && couponIds?.includes(coupon?.CoupinID)
        );
    }

    useEffect(() => {
        getCP();
    }, [user])

    useEffect(() => {
        const data_ = getCouponsForArticle(allCoupon, data?.id, coupons?.[0]?.CouponID);
        setUseCoupon(data_);
    }, [coupons])
    return (
        <>
            {isDelete ? <></> :
                <div className={`flex flex-col md:flex-row p-6 border rounded-lg shadow-lg bg-white w-10/12 justify-between font-bold py-1 px-2 rounded ${classList}`}>
                    <div className="mr-4">
                        <div className="text-xl font-bold text-gray-800 cursor-pointer hover:text-gray-600" >{data.Title}</div>
                        <div className="mt-2 text-sm text-gray-600 columns-2 flex flex-col">
                            <div className="flex flex-row">
                                <div className="">TEstlink/facebook.com</div>
                                <div className="columns-5"></div>
                                <div>{data.PublishDate}</div>
                            </div>
                            <div>
                                Subcategory:  {JSON.stringify(data.subcategory?.map(item => item.SubcategoryName))}
                            </div>
                        </div>
                        <div className={`mt-2 text-xl text-${isDiscount ? 'red' : 'green'}-500`}>Price: {data.Price}$</div>
                        {type === 'buy' && coupons?.length > 0 ?
                            <div className="mt-2 text-xl text-red-500">Discount price:
                                {Math.max(0, calDirect() + calPercent())}$
                            </div>
                            : <></>
                        }
                    </div>
                    <div>
                        <div className="flex flex-row justify-end hover:bg-gray-100 p-2 rounded-md">
                            {type === 'cart' &&
                                <div className="cursor-pointer" style={{ position: 'relative' }}>
                                    <button className="px-2 bg-red-500 hover:bg-red-700 text-white font-bold py-1 rounded"
                                        onClick={() => handleRemoveFromCart()}
                                        style={{ position: 'absolute', right: '-30px', top: '-30px' }}
                                    >
                                        X
                                    </button>
                                </div>
                            }
                        </div>
                        <div>
                            <div className="text-lg font-semibold text-gray-700">
                                <button className="w-40 bg-green-500 hover:bg-green-700 text-white font-bold py-2 px-5 rounded">Paper</button>
                            </div>
                            <div className="text-lg font-semibold text-gray-700 my-2">
                                <button onClick={() => OpenGithub(data.GithubCode)} className="w-40 bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-5 rounded">GitCode</button>
                            </div>
                            {type === 'cart' || isManage || user.role === 'admin' || type === 'buy' ?
                                <></> :
                                <div className="text-lg font-semibold text-gray-700 my-2">
                                    <button
                                        className="w-40 bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-5 rounded"
                                        onClick={() => addToCart()}
                                    >Add to Cart</button>
                                </div>
                            }
                            {type === 'cart' &&
                                <div className="text-lg font-semibold text-gray-700 my-2">
                                    <button className="w-40 bg-yellow-500 hover:bg-yellow-600 text-white font-bold py-2 px-5 rounded"
                                        onClick={() => handleBuySA()}
                                    >Buy</button>
                                </div>
                            }
                            {isManage &&
                                <div className="text-lg font-semibold text-gray-700 my-2">
                                    <button className="w-40 bg-yellow-500 hover:bg-yellow-700 text-white font-bold py-2 px-5 rounded"
                                        onClick={() => handleEdit()}
                                    >Edit</button>
                                </div>
                            }
                        </div>
                    </div>
                </div>
            }
        </>
    );
}

export default PaperCard;
