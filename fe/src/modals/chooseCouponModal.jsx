import { useState } from 'react';

function ChooseCouponModal({ coupons, setShow, show, type, setIsSelected, articleID, changePaymentUseCoupons }) {
    const [selectedCoupons, setSelectedCoupons] = useState([]);
    const handleCheckboxChange = (couponId) => {
        // selectedCoupons.includes(couponId) ? setIsSelected(articleID, couponId, 'remove') : setIsSelected(articleID, couponId, 'add');
        setSelectedCoupons((prevSelected) => {
            if (prevSelected.includes(couponId)) {
                if (type === 'article')
                    setIsSelected(articleID, couponId, 'remove');
                else if (type === 'payment') {
                    changePaymentUseCoupons(couponId, 'remove');
                }
                return prevSelected.filter((id) => id !== couponId);
            } else {
                if (type === 'article')
                    setIsSelected(articleID, couponId, 'add');
                else if (type === 'payment')
                    changePaymentUseCoupons(couponId, 'add');
                return [...prevSelected, couponId];
            }
        });
    };
    return (
        <>
            {show && (
                <div className="fixed z-50 inset-0 bg-gray-600 bg-opacity-50 flex justify-center items-center " >
                    <div className="bg-white rounded-lg shadow-lg w-3/4 max-w-xl p-6 overflow-auto" style={{ height: '80vh' }}>
                        <h2 className="text-2xl font-bold mb-4">Choose Coupon</h2>
                        <div className="space-y-4">
                            {coupons.length ? coupons?.map((item, index) => (
                                (
                                    <div
                                        key={`coupon-${index}`}
                                        className="flex items-center justify-between p-4 border border-gray-200 rounded"
                                    >
                                        <div>
                                            <div className="text-lg font-semibold text-gray-700">{item.Title}</div>
                                            <div className="text-sm text-gray-600">
                                                <div>Giảm {item.Discount} {item.DiscountUnit}</div>
                                                <div>Điều kiện Vip: {item.VipTierRequired}</div>
                                                <div>Hạn dùng đến: {new Date(item.TimeEnd).toLocaleString('en-GB', {
                                                    day: '2-digit',
                                                    month: '2-digit',
                                                    year: '2-digit',
                                                    hour: '2-digit',
                                                    minute: '2-digit',
                                                    second: '2-digit',
                                                    hour12: false,
                                                })}
                                                </div>
                                                {type === 'payment' && <div>
                                                    Loại: {item.coupon_type}
                                                    {item.coupon_type === "discount_on_subcategory" && <div>Subcategory: {JSON.stringify(item.subcategory.map(sub => sub.SubcategoryName))}</div>}
                                                    {item.coupon_type === "discount_on_academic_event" && <div>Academic Event: {JSON.stringify(item.academic_event.map(event => (event.name + '-' + event.year)))}</div>}
                                                    {item.coupon_type === "cost_base_discount" && <div>Cost condition price: {item.CostCondition}$</div>}
                                                </div>}
                                            </div>
                                        </div>

                                        <input
                                            type="checkbox"
                                            checked={selectedCoupons.includes(item.id)}
                                            onChange={() => handleCheckboxChange(item.id)}
                                            className="w-5 h-5"
                                        />

                                    </div>)
                            )) : <div>No coupons available</div>}
                        </div>
                        <div className="mt-6 flex justify-end space-x-4">
                            <button
                                className="bg-gray-300 hover:bg-gray-400 text-gray-700 font-bold py-2 px-4 rounded"
                                onClick={() => setShow(false)}
                            >
                                Cancel
                            </button>
                            {/* <button
                                className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
                                onClick={handleApply}
                            >
                                {type === 'article' ? 'Apply' : 'Apply'}
                            </button> */}
                        </div>
                    </div>
                </div>
            )}
        </>
    );
}

export default ChooseCouponModal;
