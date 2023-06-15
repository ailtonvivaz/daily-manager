import React, { useState } from 'react';

const PeopleCard = ({ name, onPressed, activeEvents, presenter }) => {
  const [hovered, setHovered] = useState(false);

  const handleMouseEnter = () => {
    setHovered(true);
  };

  const handleMouseLeave = () => {
    setHovered(false);
  };

  return (
    <div 
      onMouseEnter={handleMouseEnter}
      onMouseLeave={handleMouseLeave}
      onClick={onPressed}
    >
      {/* Render the card based on the hovered state */}
    </div>
  );
};

export default PeopleCard;
```

