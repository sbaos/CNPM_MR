import React, { useEffect, useState } from 'react';
import { BACKEND_URL } from '../const/default';
import { useSelector } from 'react-redux';
import { toast } from 'react-toastify';

function HistoryPage() {
    const [items, setItems] = useState([
        { time: '13:21:12 12/11/2024', cost: 200, id: '1' },
        { time: '14:15:45 12/11/2024', cost: 150, id: '2' },
        { time: '15:30:22 12/11/2024', cost: 100, id: '3' },
    ]);

    const [cols, setCols] = useState([
        { key: 'id', value: 'ID' },
        { key: 'time', value: 'Thời gian' },
        { key: 'cost', value: 'Tiền' },
        { key: 'average_item_cost', value: 'Trung bình' },
    ]);

    const [minPrice, setMinPrice] = useState(null);
    const [maxPrice, setMaxPrice] = useState(null);
    const [timeStart, setTimeStart] = useState(null);
    const [timeEnd, setTimeEnd] = useState(null);
    const user = useSelector((state) => state.user);
    const filteredItems = items.filter((item) => {
        const withinMin = minPrice === '' || item.cost >= parseFloat(minPrice);
        const withinMax = maxPrice === '' || item.cost <= parseFloat(maxPrice);
        // For demonstration, no filtering based on time
        return withinMin && withinMax;
    });
    const formatData = (data) => {
        return {
            time: new Date(data.time).toLocaleString('en-GB', { hour12: false }), // Format time to DD/MM/YYYY HH:mm:ss
            cost: `$${parseFloat(data.cost).toFixed(2)}`, // Format cost to currency
            id: data.id, // Keep ID as is
            average_item_cost: parseFloat(data.average_item_cost).toFixed(2), // Format average item cost
        };
    };

    const getPayment = async () => {
        if (!user?.id) return;
        // Construct the params object
        try {
            const params = {
                time_start: timeStart,
                time_end: timeEnd,
                min_price: minPrice,
                max_price: maxPrice,
                order_flag: null,
            };

            // Remove undefined or null values
            const filteredParams = Object.fromEntries(
                Object.entries(params).filter(([_, value]) => value !== undefined && value !== null && value !== "")
            );

            // Construct the query string
            const queryString = new URLSearchParams(filteredParams).toString();

            const response = await fetch(`${BACKEND_URL}/payment/getall/${user.id}?${queryString}`, {
                method: 'GET',
                headers: {
                    'Content-Type': 'application/json',
                },
            });

            // Check the response
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }

            const data = await response.json(); // Parse the response JSON
            const info = data.data.map(item => {
                return formatData(
                    {
                        "time": item.time,
                        "cost": item.cost,
                        "id": item.id,
                        "average_item_cost": item.average_item_cost
                    })
            });
            console.log(">>>>", info);
            setItems(info);
        } catch (error) {
            console.log(error);
            toast.error("Error, check your input!");
        }
    }
    const handleSearch = async () => {
        getPayment();
    }
    useEffect(() => {
        getPayment();
    }, [user]);
    return (
        <div className="p-4">
            <div className="mb-6 p-4 bg-gray-100 border border-gray-300 rounded-md">
                <h3 className="text-lg font-semibold text-gray-700 mb-4">Tìm kiếm</h3>
                <div className="mb-4 flex items-center space-x-4">
                    <div className="flex flex-1 items-center">
                        <label className="w-24 text-gray-600 text-sm font-medium mr-4">Time start:</label>
                        <input
                            type="datetime-local"
                            value={timeStart}
                            onChange={(e) => setTimeStart(e.target.value)}
                            className="flex-1 p-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                        />
                    </div>
                    <div className="flex flex-1 items-center">
                        <label className="w-24 text-gray-600 text-sm font-medium mr-4">Time end:</label>
                        <input
                            type="datetime-local"
                            value={timeEnd}
                            onChange={(e) => setTimeEnd(e.target.value)}
                            className="flex-1 p-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                        />
                    </div>
                </div>
                <div className="flex items-center space-x-4">
                    <div className="flex flex-1 items-center">
                        <label className="w-24 text-gray-600 text-sm font-medium mr-4">Min Price:</label>
                        <input
                            type="number"
                            value={minPrice}
                            onChange={(e) => setMinPrice(Math.max(0, e.target.value))}
                            placeholder="Min price"
                            className="flex-1 p-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                        />
                    </div>
                    <div className="flex flex-1 items-center">
                        <label className="w-24 text-gray-600 text-sm font-medium mr-4">Max Price:</label>
                        <input
                            type="number"
                            value={maxPrice}
                            onChange={(e) => setMaxPrice(Math.max(0, e.target.value))}
                            placeholder="Max price"
                            className="flex-1 p-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                        />
                    </div>
                </div>
            </div>
            <button className='bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-5 rounded' onClick={() => handleSearch()}>Tìm kiếm</button>
            <table className="w-full border-collapse border border-gray-300 mt-4">
                <thead>
                    <tr className="bg-gray-100">
                        {cols.map((col) => (
                            <th
                                key={col.key}
                                className="border border-gray-300 px-4 py-2 text-left font-semibold text-gray-700"
                            >
                                {col.value}
                            </th>
                        ))}
                    </tr>
                </thead>
                <tbody>
                    {items.length > 0 ? (
                        items.map((item, index) => (
                            <tr
                                key={index}
                                className={`border border-gray-300 ${index % 2 === 0 ? "bg-white" : "bg-gray-50"
                                    } hover:bg-gray-100 transition duration-200`}
                            >
                                {cols.map((col) => (
                                    <td key={col.key} className="px-4 py-2 text-gray-600">
                                        {col.key === "cost" ? `${item[col.key]}$` : item[col.key] || "N/A"}
                                    </td>
                                ))}
                            </tr>
                        ))
                    ) : (
                        <tr>
                            <td
                                colSpan={cols.length}
                                className="text-center text-gray-500 py-4"
                            >
                                No matching records found.
                            </td>
                        </tr>
                    )}
                </tbody>
            </table>

        </div>
    );
}

export default HistoryPage;
