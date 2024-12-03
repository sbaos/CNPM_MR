import React, { useState, useEffect } from 'react';
import moment from 'moment';
import { BACKEND_URL } from '../const/default';
import { useDispatch } from 'react-redux';
import { changeSA_ID } from '../redux/saSlice';
import { toast } from 'react-toastify';

const UpdateScienceArticleModal = ({ visible, onClose, article, onUpdate, action = 'update' }) => {
    const [formData, setFormData] = useState({
        Title: '',
        PublishDate: '',
        GithubCode: '',
        link: '',
        LastModified: '',
        Price: 0,
    });
    const [loading, setLoading] = useState(false);
    const dispatch = useDispatch();
    useEffect(() => {
        if (article) {
            setFormData({
                Title: article.Title || '',
                PublishDate: article.PublishDate ? moment(article.PublishDate).format('YYYY-MM-DD') : '',
                GithubCode: article.GithubCode || '',
                link: article.link || '',
                LastModified: article.LastModified ? moment(article.LastModified).format('YYYY-MM-DDTHH:mm') : '',
                Price: article.Price || 0,
            });
            console.log(article);
        }
    }, [article]);

    const handleInputChange = (e) => {
        const { name, value } = e.target;
        setFormData({ ...formData, [name]: value });
    };

    const handleUpdate = async (e) => {
        e.preventDefault();
        try {
            setLoading(true);

            // Format PublishDate as a date and LastModified as a timestamp
            const payload = {
                ...formData,
                PublishDate: moment(formData.PublishDate).format('YYYY-MM-DD'), // PublishDate is just the date
                LastModified: moment(formData.LastModified).format("YYYY-MM-DD HH:mm:ss")
            };
            const url =
                action === 'update' ?
                    `${BACKEND_URL}/science_article/update/${article.id}` :
                    `${BACKEND_URL}/science_article/add`;
            const response = await fetch(url, {
                method: action === 'update' ? 'PUT' : 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(payload),
            });

            if (response.ok) {
                dispatch(changeSA_ID({ ...payload, id: article.id }));
                onUpdate();
                toast.success('Cập nhật thành công');
                onClose();
            } else {
                toast.error('Cập nhật thất bại');
                console.error('Failed to update article');
            }
        } catch (error) {
            window.alert(JSON.stringify(error));
            console.error('Error updating article:', error);
        } finally {
            setLoading(false);
        }
    };

    if (!visible) return null;

    return (
        <div className="fixed inset-0 flex items-center justify-center bg-black bg-opacity-50 z-50">
            <div className="bg-white rounded-lg shadow-lg w-full max-w-lg p-6">
                <h2 className="text-xl font-semibold mb-4">{action === 'update' ? 'Update' : 'Add'} Science Article</h2>
                <form onSubmit={handleUpdate}>
                    <div className="mb-4">
                        <label htmlFor="Title" className="block text-sm font-medium text-gray-700">
                            Title
                        </label>
                        <input
                            type="text"
                            id="Title"
                            name="Title"
                            value={formData.Title}
                            onChange={handleInputChange}
                            className="mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                            required
                        />
                    </div>
                    <div className="mb-4">
                        <label htmlFor="PublishDate" className="block text-sm font-medium text-gray-700">
                            Publish Date
                        </label>
                        <input
                            type="date"
                            id="PublishDate"
                            name="PublishDate"
                            value={formData.PublishDate}
                            onChange={handleInputChange}
                            className="mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                            required
                        />
                    </div>
                    <div className="mb-4">
                        <label htmlFor="GithubCode" className="block text-sm font-medium text-gray-700">
                            GitHub Code
                        </label>
                        <input
                            type="text"
                            id="GithubCode"
                            name="GithubCode"
                            value={formData.GithubCode}
                            onChange={handleInputChange}
                            className="mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                            required
                        />
                    </div>
                    <div className="mb-4">
                        <label htmlFor="link" className="block text-sm font-medium text-gray-700">
                            Link
                        </label>
                        <input
                            type="url"
                            id="link"
                            name="link"
                            value={formData.link}
                            onChange={handleInputChange}
                            className="mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                            required
                        />
                    </div>
                    <div className="mb-4">
                        <label htmlFor="LastModified" className="block text-sm font-medium text-gray-700">
                            Last Modified
                        </label>
                        <input
                            type="datetime-local"
                            id="LastModified"
                            name="LastModified"
                            value={formData.LastModified}
                            onChange={handleInputChange}
                            className="mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                            required
                        />
                    </div>
                    {action === 'add' && <div className="mb-4">
                        <label htmlFor="Price" className="block text-sm font-medium text-gray-700">
                            Price
                        </label>
                        <input
                            type="number"
                            id="Price"
                            name="Price"
                            value={formData.Price}
                            onChange={handleInputChange}
                            className="mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                            required
                            min="0"
                        />
                    </div>}
                    <div className="flex justify-end space-x-2">
                        <button
                            type="button"
                            onClick={onClose}
                            className="py-2 px-4 bg-gray-300 text-gray-700 rounded-md hover:bg-gray-400"
                        >
                            Cancel
                        </button>
                        <button
                            type="submit"
                            disabled={loading}
                            className={`py-2 px-4 text-white rounded-md ${loading ? 'bg-gray-400' : 'bg-indigo-600 hover:bg-indigo-700'
                                }`}
                        >
                            {loading ? action === 'update' ? 'Updating...' : 'Adding...' : action === 'update' ? 'Update' : 'Add'}
                        </button>
                    </div>
                </form>
            </div>
        </div>
    );
};

export default UpdateScienceArticleModal;
