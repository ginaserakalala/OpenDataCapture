import React from 'react';

import DemographicsForm from '../components/DemographicsForm';

export const DemographicsPage: React.FC = () => {
  const handleFormSubmit = (formData: { name: string; dob: string; schoolId: string; grade: string }) => {
    console.log('Form Submitted:', formData);
    // Navigate to the next page or display success
  };

  return (
    <div>
      <h1>Demographics Form</h1>
      <DemographicsForm onSubmit={handleFormSubmit} />
    </div>
  );
};
