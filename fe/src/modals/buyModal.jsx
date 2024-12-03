import { useEffect, useState } from "react";
import { useSelector } from "react-redux";
import getAllCoupon from "../utils/getAllCoupon";
import PaperCard from "../component/paperCard";
import ChooseCouponModal from "./chooseCouponModal";
import { BACKEND_URL } from "../const/default";
import { toast } from "react-toastify";

function BuyModal({ items, setShow, show, selectedArticles, setSelectedArticles,
    articleUseCoupons, setArticleUseCoupons
}) {
    const user = useSelector((state) => state.user);
    const [loading, setLoading] = useState(false);
    const [articleCoupons, setArticleCoupons] = useState([]);
    const [paymentCoupons, setPaymentCoupons] = useState([]);
    const [selectedArticle, setSelectedArticle] = useState();
    const [showChooseCoupon, setShowChooseCoupon] = useState(false);
    const [coupons, setCoupons] = useState([]);
    const [paymentUseCoupons, setPaymentUseCoupons] = useState([]);
    const [type, setType] = useState('article');

    function convertToNumber(priceString) {
        return parseFloat(priceString);

        // return parseFloat(priceString.replace('$', ''));
    }
    function calcuBasePrice() {
        return items?.reduce((acc, item) => acc + parseFloat(item.Price.replace("$", "")), 0).toFixed(2)
    }
    function calculateFinalPrice_SubofItem(item) {
        const coupon = paymentCoupons?.filter(coupon => coupon.coupon_type === "discount_on_subcategory");
        console.log(coupon);
        console.log(item);
        let canuse = coupon?.filter(coupon =>
            item?.subcategory?.some(sub =>
                coupon?.subcategory?.some(couponSub => couponSub.SubcategoryName === sub.SubcategoryName)
            )
        );
        console.log(canuse);
        console.log(paymentUseCoupons);
        canuse = canuse?.filter(coupon => paymentUseCoupons.includes(coupon.id));
        console.log(canuse);
        let sum = 0;
        for (let i = 0; i < canuse.length; i++) {
            if (canuse?.[i]?.DiscountUnit === '%')
                sum += (item.Price * (canuse[i].Discount / 100));
            else
                sum += canuse?.[i]?.Discount;
        }
        console.log(sum);
        return sum;
    }
    function calculateFinalPrice_AcaofItem(item) {
        const coupon = paymentCoupons?.filter(coupon => coupon.coupon_type === "discount_on_academic_event");
        let canuse = coupon?.filter(coupon =>
            item?.academic_event?.some(event =>
                coupon?.academic_event?.some(couponEvent => couponEvent.id === event.id)
            )
        );

        canuse = canuse?.filter(coupon => paymentUseCoupons.includes(coupon.id));
        console.log(canuse);
        let sum = 0;
        for (let i = 0; i < canuse.length; i++) {
            if (canuse[i].DiscountUnit === '%')
                sum += (item.Price * (canuse[i].Discount / 100));
            else
                sum += canuse[i].Discount;
        }
        console.log(sum);
        return sum;
    }
    function calculateCosBaseDiscount() {
        let coupon = coupons?.filter(coupon => paymentUseCoupons.includes(coupon.id));
        const basePrice = calcuBasePrice();
        coupon = coupon.filter(item => (item.coupon_type === "cost_base_discount" && item.CostCondition * 1.0 <= basePrice * 1.0))
        let totalP = 0;
        let totalS = 0;
        console.log(coupon);
        if (!coupon?.length) return 0;
        for (let i = 0; i < coupon.length; i++) {
            if (coupon?.[i]?.DiscountUnit === '%')
                totalP += coupon[i].Discount * basePrice / 100;
            else
                totalS += coupon?.[i]?.Discount
        }
        return totalP + totalS;
    }
    const calFinalPrice = (price) => {
        const coupon = items.map((item) =>
            getCouponsForArticle(
                coupons,
                item?.id,
                articleUseCoupons.filter(a =>
                    a.ArticleID === item.id)?.[0]?.CouponID));
        console.log(coupon);

        let itemPrice = items.map((item, index) => calculateFinalPrice(item, coupon[index]));
        console.log(itemPrice);
        let sum = itemPrice.reduce((acc, item) => acc + item, 0);

        return sum;

    }
    const calItemACP = (item) => {
        const coupon = getCouponsForArticle(
            coupons,
            item?.id,
            articleUseCoupons.filter(a =>
                a.ArticleID === item.id)?.[0]?.CouponID);
        return calculateFinalPrice(item, coupon);

    }
    function calculateFinalPrice(item) {
        const coupons = articleCoupons;
        let finalPrice = item.Price;  // Start with the original price of the item
        articleUseCoupons.filter(a => a.ArticleID === item.id)

        // Filter coupons that apply to the specific item
        let applicableCoupons = coupons?.filter(coupon =>
            coupon.ArticleID === item.id  // Check if the coupon is for this article
        );

        applicableCoupons = applicableCoupons?.filter(coupon => articleUseCoupons.find(item => item.ArticleID === coupon.ArticleID)?.CouponID?.includes(coupon.id));
        if (!applicableCoupons?.length) return finalPrice;

        // Apply each applicable coupon to the final price
        applicableCoupons?.forEach(coupon => {
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
    const finalPrice = () => {
        const itemPrice = items.map((item) =>
            Math.max(
                calculateFinalPrice(item)
                - calculateFinalPrice_AcaofItem(item)
                - calculateFinalPrice_SubofItem(item)
                , 0
            )
        );
        console.log(itemPrice);
        console.log(calculateCosBaseDiscount());
        return itemPrice.reduce((acc, item) => acc + item, 0) - calculateCosBaseDiscount();
    }
    const getCoupon = async () => {
        try {
            setLoading(true);
            const res = await getAllCoupon(user.id);
            const article_coupon_data = res.article_coupon_data;
            console.log(article_coupon_data)
            const payment_coupon_data = res.payment_coupon_data;
            console.log(payment_coupon_data);
            setArticleCoupons(article_coupon_data);
            setPaymentCoupons(payment_coupon_data);
        } catch (error) {
            console.error("Error fetching coupons:", error);
        } finally {
            setLoading(false);
        }
    };
    function getCouponsForArticle(coupons, articleId, couponIds) {
        if (!coupons?.length) return [];
        return coupons?.filter(coupon =>
            coupon?.ArticleID === articleId && couponIds?.includes(coupon?.CoupinID)
        );
    }


    const changePaymentUseCoupons = (couponID, action = 'add') => {
        if (action === 'add') {
            setPaymentUseCoupons([...paymentUseCoupons, couponID]);
        } else {
            setPaymentUseCoupons(paymentUseCoupons.filter(id => id !== couponID))
        }
    }
    const handleApplyOnArticle = async (id) => {
        console.log(articleUseCoupons);
        const coupon = articleCoupons?.filter(
            (item) =>
                item.ArticleID === id &&
                !articleUseCoupons?.some(
                    (usedArticle) =>
                        usedArticle?.ArticleID !== id && usedArticle?.CouponID?.includes(item.CoupinID)
                )
        );
        setType('article');
        setSelectedArticle(id);
        setCoupons(coupon);
        setShowChooseCoupon(true);
    };
    const handleApplyOnPayment = async () => {
        const coupon = paymentCoupons;
        console.log('A>>>>', articleUseCoupons);
        console.log('B>>>>', paymentUseCoupons);
        setType('payment');
        setCoupons(coupon);
        setShowChooseCoupon(true);
    };
    const updateArticleUseCoupons = () => {

        if (!selectedArticles?.length) return [];
        const newData = selectedArticles.map((article) => {
            const existing = articleUseCoupons.find((item) => item.ArticleID === article.id);
            return { ArticleID: article.id, CouponID: existing?.CouponID || [] };
        });

        return newData;
    };
    const updatePaymentUseCoupons = () => {
        if (!paymentUseCoupons?.length) return [];
        const coupon = paymentCoupons.filter(item => paymentUseCoupons.includes(item.id));
        const newData = coupon.map((item) => {
            return { "CouponID": item.id, "coupon_type": item.coupon_type };
        })
        return newData;
    };
    const handleBuy = async (id) => {
        const Items = updateArticleUseCoupons();

        const paymentApply = updatePaymentUseCoupons();
        const data = {
            Items,
            paymentApply
        }
        let count = 0;
        for (let i = 0; i < Items.length; i++) {
            count += Items[i].CouponID.length;
        }
        count += paymentApply.length;
        if (count > 2) {
            toast.error('Số lượng coupon được áp dụng vượt quá giới hạn');
            return;
        }
        const res = await fetch(`${BACKEND_URL}/payment/create/${user.id}`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json', // Specify JSON content type
            },
            body: JSON.stringify({
                Items,
                paymentApply
            })
        })
        if (res.ok) {
            toast.success('Mua thành công');
            setShow(false);
            setTimeout(() => {
                window.location.reload();
            }, 1000)

        }
        console.log(res);
    }
    const setIsSelected = (articleID, couponID, action = 'add') => {
        console.log('=======', articleUseCoupons);
        if (action === 'add') {
            const data = articleUseCoupons?.filter(item => item.ArticleID === articleID)?.[0];
            if (!data) {
                const newData = [{ ArticleID: articleID, CouponID: [couponID] }];
                console.log(newData);
                setArticleUseCoupons(newData);
            } else {
                const newData = articleUseCoupons.some((item) => item.ArticleID === articleID)
                    ? articleUseCoupons.map((item) =>
                        item.ArticleID === articleID
                            ? {
                                ...item,
                                CouponID: [...new Set([...item.CouponID, couponID])], // Ensure no duplicate coupons
                            }
                            : item
                    )
                    : [...articleUseCoupons, { ArticleID: articleID, CouponID: [couponID] }];
                setArticleUseCoupons(newData);
            }
        } else if (action === 'remove') {
            const data = articleUseCoupons?.filter(item => item.ArticleID === articleID)?.[0];
            if (!data) return;
            const newData = articleUseCoupons.some((item) => item.ArticleID === articleID)
                ? articleUseCoupons.map((item) =>
                    item.ArticleID === articleID
                        ? {
                            ...item,
                            CouponID: item.CouponID.includes(couponID)
                                ? item.CouponID.filter((id) => id !== couponID) // Remove couponID
                                : [...item.CouponID], // Add couponID if not exists
                        }
                        : item
                )
                : [...articleUseCoupons, { ArticleID: articleID, CouponID: [couponID] }];
            setArticleUseCoupons(newData);
        }
    }
    console.log(articleUseCoupons)
    useEffect(() => {
        getCoupon();
    }, [user]);
    let _;
    return (
        <>
            {show && (
                <div className="fixed inset-0 z-30 flex items-center justify-center bg-black bg-opacity-50">
                    {/* Modal Content */}
                    <div className="bg-white w-11/12 rounded-lg shadow-lg max-w-3xl w-full mx-4 p-6 relative" style={{ height: '90vh' }}>
                        {/* Close Button */}
                        <button
                            onClick={() => setShow(false)}
                            className="absolute top-3 right-3 text-gray-600 hover:text-black"
                        >
                            ✕
                        </button>

                        <h2 className="text-lg font-semibold mb-4">Confirm your order</h2>

                        <div className="space-y-4">


                            {items?.length > 0 ? (
                                <div >
                                    <div className="overflow-y-auto h-72">
                                        {items.map((item, index) => (
                                            <div key={`cartItem-${index}`} className="flex flex-row justify-between items-center p-4 w-full">
                                                <PaperCard
                                                    data={item}
                                                    classList="mx-auto my-2"
                                                    type="buy"
                                                    coupons={articleUseCoupons.filter(a => a.ArticleID === item.id)}

                                                />
                                                <button className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-5 rounded"
                                                    onClick={() => handleApplyOnArticle(item.id)}
                                                >
                                                    Apply
                                                </button>
                                            </div>
                                        ))}
                                    </div>
                                    <button className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-5 rounded"
                                        onClick={() => handleApplyOnPayment()}
                                    >
                                        Apply
                                    </button>
                                    <div className="flex flex-col justify-between items-center">
                                        <div className="text-center text-green-500">
                                            Base price: {calcuBasePrice()}$
                                        </div>
                                        <div className="text-center text-red-500">
                                            Final price: {finalPrice()}$
                                        </div>
                                    </div>
                                </div>
                            ) : (
                                <p className="text-center text-gray-500">No items in cart</p>
                            )}
                        </div>

                        {/* Footer */}
                        <div className="mt-6 flex justify-end">
                            <button
                                onClick={() => setShow(false)}
                                className="px-4 py-2 text-sm font-medium text-white bg-gray-600 rounded-lg hover:bg-gray-700"
                            >
                                Close
                            </button>
                            <button
                                onClick={() => handleBuy()}
                                className="px-4 mx-2 py-2 text-sm font-medium text-white bg-green-600 rounded-lg hover:bg-green-700"
                            >
                                Buy
                            </button>
                        </div>
                    </div>
                </div >
            )
            }
            <ChooseCouponModal changePaymentUseCoupons={changePaymentUseCoupons} articleID={selectedArticle} setIsSelected={setIsSelected} coupons={coupons} setShow={setShowChooseCoupon} show={showChooseCoupon} type={type} />
        </>
    );
}

export default BuyModal;
