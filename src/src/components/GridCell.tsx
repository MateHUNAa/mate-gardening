import React from "react";

interface GridCellProps {
  index: number;
  active: boolean;
  imagePath: string;
}

const GridCell: React.FC<GridCellProps> = ({ index, active }) => {
  return (
    <div
      className={`relative flex h-full w-full select-none items-center justify-center bg-cover bg-center ${active ? "shadow-inner shadow-black/40" : ""}`}
      style={
        active
          ? {
              backgroundImage: "url('soil.png')",
              margin: `${index * 0.13}px`,
            }
          : {
              background: "transparent !important",
            }
      }
      data-index={index}
    />
  );
};

export default GridCell;
