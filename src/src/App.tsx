import { useState, useEffect } from "react";
import { useNuiEvent } from "@/hooks/useNuiEvent";
import { debugData } from "@/utils/debugData";
import type { Plant } from "@/types/plant";
import PlantCard from "@/components/plantCard";
import { isEnvBrowser } from "./utils/misc";
import GridWrapper from "./components/GridWrapper";

function App() {
  const [visible, setVisibility] = useState<boolean>(
    isEnvBrowser() ? true : false,
  );

  useNuiEvent("open", () => setVisibility(true));
  useNuiEvent("close", () => setVisibility(false));

  return (
    <div className="App">
      {visible && <div></div>}

      <PlantCard />
      <GridWrapper defaultRows={5} defaultCols={5} defaultImage="soil.png" />
    </div>
  );
}

debugData<Plant>([
  {
    action: "sendPlantData",
    data: { name: "Aloe", water: 50, health: 88, stage: 3, maxstage: 5 },
  },
]);

export default App;
