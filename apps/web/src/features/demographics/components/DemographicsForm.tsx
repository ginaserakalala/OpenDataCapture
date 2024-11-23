import React, { useState } from 'react';

type DemographicsFormData = {
  consentGiven: boolean;
  dob: string;
  grade: string;
  name: string;
  schoolId: string;
};

type DemographicsFormProps = {
  onSubmit: (formData: Omit<DemographicsFormData, 'consentGiven'>) => void;
};

const DemographicsForm: React.FC<DemographicsFormProps> = ({ onSubmit }) => {
  const [formData, setFormData] = useState<DemographicsFormData>({
    consentGiven: false,
    dob: '',
    grade: '',
    name: '',
    schoolId: ''
  });

  const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLSelectElement>) => {
    const target = e.target;
    const value = target.type === 'checkbox' ? (target as HTMLInputElement).checked : target.value;
    const name = target.name;

    setFormData((prevData) => ({
      ...prevData,
      [name]: value
    }));
  };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (formData.consentGiven) {
      onSubmit({
        dob: formData.dob,
        grade: formData.grade,
        name: formData.name,
        schoolId: formData.schoolId
      });
    }
  };

  return (
    <form onSubmit={handleSubmit}>
      <div>
        <label>Name:</label>
        <input required name="name" type="text" value={formData.name} onChange={handleChange} />
      </div>
      <div>
        <label>Date of Birth:</label>
        <input required name="dob" type="date" value={formData.dob} onChange={handleChange} />
      </div>
      <div>
        <label>School ID:</label>
        <input required name="schoolId" type="text" value={formData.schoolId} onChange={handleChange} />
      </div>
      <div>
        <label>Grade:</label>
        <select required name="grade" value={formData.grade} onChange={handleChange}>
          <option disabled value="">
            Select Grade
          </option>
          <option value="1">Grade 1</option>
          <option value="2">Grade 2</option>
          <option value="3">Grade 3</option>
          {/* Add more grades as needed */}
        </select>
      </div>
      <div>
        <label>
          <input checked={formData.consentGiven} name="consentGiven" type="checkbox" onChange={handleChange} />
          Consent form sent through
        </label>
      </div>
      <button disabled={!formData.consentGiven} type="submit">
        Submit
      </button>
    </form>
  );
};

export default DemographicsForm;
