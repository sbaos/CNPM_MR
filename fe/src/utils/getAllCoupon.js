import { BACKEND_URL } from "../const/default";

const getAllCoupon = async (ReaderID) => {
    if (!ReaderID) return;
    const response = await fetch(`${BACKEND_URL}/coupon/appliable/${ReaderID}`, {
        method: 'GET',
        headers: {
            'Content-Type': 'application/json',
        },
    });
    const data = await response.json();
    return data;
};

export default getAllCoupon;