import { useLocation } from "react-router-dom";
import PaperCard from "../component/paperCard";
import { findContentCondition } from "../const/fillerCondition";
import { useEffect, useState } from "react";
import { useDispatch, useSelector } from "react-redux";
import { addSA, initSA } from "../redux/saSlice";
import getAllCoupon from "../utils/getAllCoupon";
import { BACKEND_URL } from "../const/default";

function HomePage() {
    const location = useLocation();
    const queryParams = new URLSearchParams(location.search);
    const user = useSelector(state => state.user);
    const dispatch = useDispatch();
    const scienceArticles = useSelector(state => state.sa.list);
    const [findCondition, setFindCondition] = useState(
        findContentCondition.map((item) => ({ ...item, value: "" }))
    );
    const handleChangeCondition = (index, value) => {
        const newCondition = [...findCondition];
        newCondition[index].value = value;
        setFindCondition(newCondition);
    };

    const getPaper = async () => {
        try {
            const backendUrl = process.env.REACT_APP_BACKEND_URL || "http://localhost:8080/api/v1";
            const response = await fetch(`${backendUrl}/science_article/${user.id}`, {
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
    const sortNew = () => {
        // Sort the science articles by PublishDate in descending order
        const sortedArticles = [...scienceArticles].sort((a, b) => {
            const dateA = new Date(a.PublishDate);
            const dateB = new Date(b.PublishDate);
            return dateB - dateA; // Descending order
        });
        dispatch(initSA(sortedArticles));
    };
    const sortOld = () => {
        // Sort the science articles by PublishDate in ascending order (oldest first)
        const sortedArticles = [...scienceArticles].sort((a, b) => {
            const dateA = new Date(a.PublishDate);
            const dateB = new Date(b.PublishDate);
            return dateA - dateB; // Ascending order
        });

        dispatch(initSA(sortedArticles)); // Update Redux store with sorted articles
    };

    const handleSearch = async () => {
        try {
            const queryParams = new URLSearchParams(
                findCondition.map(item => [item.key, item.value])
            ).toString();

            const response = await fetch(`${BACKEND_URL}/science_article/filtered/${user.id}?${queryParams}`, {
                method: "GET",
                headers: {
                    "Content-Type": "application/json",
                },
            });

            if (!response.ok) {
                throw new Error(`HTTP error! Status: ${response.status}`);
            }
            const data = await response.json();
            const info = data.data.filter(item => !item.deleteAt);
            const hasBuy_ = findCondition.find(item => item.key === 'hasBuy')?.value;
            let info_ = info;
            if (hasBuy_ === 'true')
                info_ = info_.filter(item => item.hasBuy === true);
            else if (hasBuy_ === 'false')
                info_ = info_.filter(item => item.hasBuy === false);
            console.log(info_);
            dispatch(initSA(info_));
        } catch (error) {
            console.log(error);
        }
    };
    console.log(scienceArticles)
    useEffect(() => {
        getPaper();
        getAllCoupon(user.id);
    }, [user]);

    return (
        <div>
            <div>
                <span>Tìm paper với điều kiện:</span>
                <div className="flex flex-column justify-around">
                    <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-4 gap-4">
                        {findCondition.map((item, index) => (
                            <div key={`conditionContent-${index}`}>
                                {item.key === "year" ? (
                                    <select
                                        className="w-full border border-gray-400 px-2 py-1 rounded"
                                        value={findCondition[index].value || ''}
                                        onChange={(e) => handleChangeCondition(index, e.target.value)}
                                    >
                                        <option value="" disabled>Select Year</option>
                                        <option value=""></option>
                                        {/* Generate year options dynamically */}
                                        {Array.from({ length: 50 }, (_, i) => {
                                            const year = new Date().getFullYear() - i; // Generate last 50 years
                                            return (
                                                <option key={year} value={year}>
                                                    {year}
                                                </option>
                                            );
                                        })}
                                    </select>
                                ) : item.key === 'hasBuy' ?
                                    <select
                                        className="w-full border border-gray-400 px-2 py-1 rounded"
                                        value={findCondition[index].value || ''}
                                        onChange={(e) => handleChangeCondition(index, e.target.value)}
                                    >
                                        <option value="" disabled>HasBuy</option>
                                        <option value="">None</option>
                                        <option value="true">True</option>
                                        <option value="false">False</option>
                                    </select>
                                    :
                                    <input
                                        type="text"
                                        className="w-full border border-gray-400 px-2 py-1 rounded"
                                        placeholder={`Enter ${item.key}`}
                                        value={findCondition[index].value || ''}
                                        onChange={(e) => handleChangeCondition(index, e.target.value)}
                                    />
                                }
                            </div>
                        ))}

                        <div>
                            <button className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-5 rounded"
                                onClick={() => handleSearch()}>
                                Tìm kiếm
                            </button>
                        </div>
                    </div>
                </div>
                <div>
                    <div className="rounded-md p-4">
                        {/* <button className="border border-gray-400 px-4 py-2 rounded-md hover:bg-gray-100">
                                Top
                            </button> */}
                        <button className="border border-gray-400 px-4 py-2 rounded-md mx-2 hover:bg-gray-100"
                            onClick={() => sortNew()}>
                            New
                        </button>
                        <button className="border border-gray-400 px-4 py-2 rounded-md hover:bg-gray-100"
                            onClick={() => sortOld()}>
                            Old
                        </button>
                    </div>
                    <h1 className="text-2xl font-bold text-gray-800 mb-4">Trending Research</h1>
                    <div className="flex flex-col justify-center">
                        {scienceArticles.length > 0 ? (
                            scienceArticles.map((article, index) => (
                                <div key={index} className="w-full mb-4">
                                    <PaperCard data={article} classList="mx-auto" />
                                </div>
                            ))
                        ) : (
                            <p>No articles found.</p>
                        )}
                    </div>
                </div>
            </div>
        </div>
    );
}

export default HomePage;



// import { useLocation } from "react-router-dom";
// import PaperCard from "../component/paperCard";
// import { findContentCondition } from "../const/fillerCondition";
// import { useEffect, useState } from "react";
// import { useDispatch, useSelector } from "react-redux";
// import { addSA, initSA } from "../redux/saSlice";
// import getAllCoupon from "../utils/getAllCoupon";
// import { BACKEND_URL } from "../const/default";

// function HomePage() {
//     const [file, setFile] = useState();
//     const location = useLocation();
//     const queryParams = new URLSearchParams(location.search);
//     const user = useSelector(state => state.user);
//     const dispatch = useDispatch();
//     const scienceArticles = useSelector(state => state.sa.list);
//     const [findCondition, setFindCondition] = useState(
//         findContentCondition.map((item) => ({ ...item, value: "" }))
//     );
//     const handleChangeCondition = (index, value) => {
//         const newCondition = [...findCondition];
//         newCondition[index].value = value;
//         setFindCondition(newCondition);
//     };

//     const getPaper = async () => {
//         try {
//             const backendUrl = process.env.REACT_APP_BACKEND_URL || "http://localhost:8080/api/v1";
//             const response = await fetch(`${backendUrl}/science_article`, {
//                 method: "GET",
//             });

//             if (!response.ok) {
//                 throw new Error(`HTTP error! Status: ${response.status}`);
//             }
//             console.log(">>>")
//             const data = await response.json();
//             console.log("data>>>>", data)
//             const info = data.data.filter(item => !item.deleteAt);
//             console.log("infor>>>>", info);
//             dispatch(initSA(info));
//         } catch (error) {
//             console.error("Error fetching papers:", error.message);
//         }
//     };
//     const sortNew = () => {
//         // Sort the science articles by PublishDate in descending order
//         const sortedArticles = [...scienceArticles].sort((a, b) => {
//             const dateA = new Date(a.PublishDate);
//             const dateB = new Date(b.PublishDate);
//             return dateB - dateA; // Descending order
//         });
//         dispatch(initSA(sortedArticles));
//     };
//     const sortOld = () => {
//         // Sort the science articles by PublishDate in ascending order (oldest first)
//         const sortedArticles = [...scienceArticles].sort((a, b) => {
//             const dateA = new Date(a.PublishDate);
//             const dateB = new Date(b.PublishDate);
//             return dateA - dateB; // Ascending order
//         });

//         dispatch(initSA(sortedArticles)); // Update Redux store with sorted articles
//     };

//     const handleSearch = async () => {
//         try {
//             const queryParams = new URLSearchParams(
//                 findCondition.map(item => [item.key, item.value])
//             ).toString();

//             const response = await fetch(`${BACKEND_URL}/science_article/filtered/?${queryParams}`, {
//                 method: "GET",
//                 headers: {
//                     "Content-Type": "application/json",
//                 },
//             });

//             if (!response.ok) {
//                 throw new Error(`HTTP error! Status: ${response.status}`);
//             }
//             const data = await response.json();
//             console.log(">>>>>>", data.data[0])
//             const info = data.data[0].filter(item => !item.deleteAt);
//             const hasBuy_ = findCondition.find(item => item.key === 'hasBuy')?.value;
//             let info_ = info;
//             if (hasBuy_ === 'true')
//                 info_ = info_.filter(item => item.hasBuy === true);
//             else if (hasBuy_ === 'false')
//                 info_ = info_.filter(item => item.hasBuy === false);
//             console.log("infor>>>>", info_);
//             dispatch(initSA(info_));
//         } catch (error) {
//             console.log(error);
//         }
//     };
//     console.log(scienceArticles)
//     useEffect(() => {
//         getPaper();
//         // getAllCoupon(user.id);
//     }, [user]);
//     const handleFileChange = (e) => {
//         const selectedFile = e.target.files[0];
//         console.log(selectedFile); // Log the file details
//         setFile(selectedFile);
//     };
//     return (
//         <div>
//             <div>
//                 <span>Tìm paper với điều kiện:</span>
//                 <div className="flex flex-column justify-around">
//                     <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-4 gap-4">
//                         {findCondition.map((item, index) => (
//                             <div key={`conditionContent-${index}`}>
//                                 {item.key === "year" ? (
//                                     <select
//                                         className="w-full border border-gray-400 px-2 py-1 rounded"
//                                         value={findCondition[index].value || ''}
//                                         onChange={(e) => handleChangeCondition(index, e.target.value)}
//                                     >
//                                         <option value="" disabled>Select Year</option>
//                                         <option value=""></option>
//                                         {/* Generate year options dynamically */}
//                                         {Array.from({ length: 50 }, (_, i) => {
//                                             const year = new Date().getFullYear() - i; // Generate last 50 years
//                                             return (
//                                                 <option key={year} value={year}>
//                                                     {year}
//                                                 </option>
//                                             );
//                                         })}
//                                     </select>
//                                 ) : item.key === 'hasBuy' ?
//                                     <select
//                                         className="w-full border border-gray-400 px-2 py-1 rounded"
//                                         value={findCondition[index].value || ''}
//                                         onChange={(e) => handleChangeCondition(index, e.target.value)}
//                                     >
//                                         <option value="" disabled>HasBuy</option>
//                                         <option value="">None</option>
//                                         <option value="true">True</option>
//                                         <option value="false">False</option>
//                                     </select>
//                                     :
//                                     <input
//                                         type="text"
//                                         className="w-full border border-gray-400 px-2 py-1 rounded"
//                                         placeholder={`Enter ${item.key}`}
//                                         value={findCondition[index].value || ''}
//                                         onChange={(e) => handleChangeCondition(index, e.target.value)}
//                                     />
//                                 }
//                             </div>
//                         ))}

//                         <div>
//                             <button className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-5 rounded"
//                                 onClick={() => handleSearch()}>
//                                 Tìm kiếm
//                             </button>
//                         </div>
//                         {/* <div>
//                             <input type="file" onChange={handleFileChange} />
//                         </div>
//                         <iframe
//                             src={URL.createObjectURL(file)}
//                             title="PDF Viewer"
//                             width="100%"
//                             height="600px"
//                             style={{ border: 'none' }}
//                         ></iframe>
//                         {file.name} */}
//                     </div>
//                 </div>
//                 <div>
//                     <div className="rounded-md p-4">
//                         {/* <button className="border border-gray-400 px-4 py-2 rounded-md hover:bg-gray-100">
//                                 Top
//                             </button> */}
//                         <button className="border border-gray-400 px-4 py-2 rounded-md mx-2 hover:bg-gray-100"
//                             onClick={() => sortNew()}>
//                             New
//                         </button>
//                         <button className="border border-gray-400 px-4 py-2 rounded-md hover:bg-gray-100"
//                             onClick={() => sortOld()}>
//                             Old
//                         </button>
//                     </div>
//                     <h1 className="text-2xl font-bold text-gray-800 mb-4">Trending Research</h1>
//                     <div className="flex flex-col justify-center">
//                         {scienceArticles.length > 0 ? (
//                             scienceArticles.map((article, index) => (
//                                 <div key={index} className="w-full mb-4">
//                                     <PaperCard data={article} classList="mx-auto" />
//                                 </div>
//                             ))
//                         ) : (
//                             <p>No articles found.</p>
//                         )}
//                     </div>
//                 </div>
//             </div>
//         </div>
//     );
// }

// export default HomePage;
// // import React, { useState, useEffect } from 'react';
// // import { getDocument } from 'pdfjs-dist';
// // import { GlobalWorkerOptions } from 'pdfjs-dist';
// // const HomePage = () => {
// //     const [file, setFile] = useState(null);
// //     const [fileUrl, setFileUrl] = useState(null);
// //     const [numPages, setNumPages] = useState(0);
// //     GlobalWorkerOptions.workerSrc = 'https://cdnjs.cloudflare.com/ajax/libs/pdf.js/2.14.305/pdf.worker.min.js';

// //     const handleFileChange = async (event) => {
// //         const selectedFile = event.target.files[0];
// //         if (selectedFile) {
// //             const fileBlobUrl = URL.createObjectURL(selectedFile);
// //             setFile(selectedFile);
// //             setFileUrl(fileBlobUrl);

// //             // Load the PDF and get the number of pages
// //             try {
// //                 const pdf = await getDocument(fileBlobUrl).promise;
// //                 setNumPages(pdf.numPages);
// //             } catch (error) {
// //                 console.error('Error loading PDF:', error);
// //             }
// //         }
// //     };

// //     // Cleanup the Blob URL to prevent memory leaks
// //     useEffect(() => {
// //         return () => {
// //             if (fileUrl) {
// //                 URL.revokeObjectURL(fileUrl);
// //             }
// //         };
// //     }, [fileUrl]);

// //     return (
// //         <div>
// //             <div>
// //                 <button
// //                     className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-5 rounded"
// //                     onClick={() => alert('Search functionality is not implemented yet.')}
// //                 >
// //                     Tìm kiếm
// //                 </button>
// //             </div>
// //             <div>
// //                 <input type="file" accept="application/pdf" onChange={handleFileChange} />
// //             </div>
// //             {fileUrl && (
// //                 <>
// //                     <iframe
// //                         src={fileUrl}
// //                         title="PDF Viewer"
// //                         width="100%"
// //                         height="400px"
// //                         style={{ border: 'none' }}
// //                     ></iframe>
// //                     <p className="mt-4">Total Pages: {numPages}</p>
// //                 </>
// //             )}
// //         </div>
// //     );
// // };

// // export default HomePage;
