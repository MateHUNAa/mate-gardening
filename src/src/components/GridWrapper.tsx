import React, { useState, useEffect } from "react";
import GridCell from "@/components/GridCell";
import useNuiEvent from "@/hooks/useNuiEvent";
import { isEnvBrowser } from "@/utils/misc";

interface GridWrapperProps {
  defaultRows: number;
  defaultCols: number;
  defaultImage: string;
}

const GridWrapper: React.FC<GridWrapperProps> = ({
  defaultRows,
  defaultCols,
  defaultImage,
}) => {
  const [show, setShow] = useState(isEnvBrowser() ? true : false);
  const [rows, setRows] = useState(defaultRows);
  const [cols, setCols] = useState(defaultCols);
  const [imagePath, setImagePath] = useState(defaultImage);
  const [cells, setCells] = useState<Record<number, boolean>>({});

  useNuiEvent("setCell", (data) => {
    setCells((prev) => ({ ...prev, [data.index]: !!data.useImage }));
  });

  useNuiEvent("buildGrid", (data) => {
    setRows(data.rows ?? defaultRows);
    setCols(data.cols ?? defaultCols);
    setCells({});
  });

  useNuiEvent("toggleGrid", (data) => {
    setShow(data ?? !show);
  });

  if (!show) return null;

  const total = rows * cols;
  const list = Array.from({ length: total }, (_, i) => i);

  return (
    <div className="flex h-full w-full items-center justify-center p-4">
      <div
        className="grid gap-[5.5px]"
        style={{
          gridTemplateColumns: `repeat(${cols}, 96px)`,
          gridAutoRows: "96px",
        }}
      >
        {list.map((i) => (
          <GridCell
            key={i}
            index={i}
            active={cells[i] ?? false}
            imagePath={imagePath}
          />
        ))}
      </div>
    </div>
  );
};

export default GridWrapper;
