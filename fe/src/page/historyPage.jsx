import React, { useState } from 'react';

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
    ]);

    const [minPrice, setMinPrice] = useState('');
    const [maxPrice, setMaxPrice] = useState('');
    const [timeStart, setTimeStart] = useState('');
    const [timeEnd, setTimeEnd] = useState('');

    const filteredItems = items.filter((item) => {
        const withinMin = minPrice === '' || item.cost >= parseFloat(minPrice);
        const withinMax = maxPrice === '' || item.cost <= parseFloat(maxPrice);
        // For demonstration, no filtering based on time
        return withinMin && withinMax;
    });

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
            <table className="w-full border-collapse border border-gray-300">
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
                    {filteredItems.map((item, index) => (
                        <tr
                            key={index}
                            className="border border-gray-300 hover:bg-gray-50 transition duration-200"
                        >
                            {cols.map((col) => (
                                <td key={col.key} className="px-4 py-2 text-gray-600">
                                    {col.key === 'cost' ? `${item[col.key]}$` : item[col.key]}
                                </td>
                            ))}
                        </tr>
                    ))}
                </tbody>
            </table>
        </div>
    );
}

export default HistoryPage;
