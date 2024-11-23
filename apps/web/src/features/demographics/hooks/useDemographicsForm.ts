import { useState } from 'react';

export const useDemographicsForm = () => {
  const [formData, setFormData] = useState({
    name: '',
    dob: '',
    schoolId: '',
    grade: '',
    consentGiven: false
  });

  const updateFormData = (field: string, value: string | boolean) => {
    setFormData((prev) => ({ ...prev, [field]: value }));
  };

  return { formData, updateFormData };
};
