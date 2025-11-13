import { useState, useEffect } from "react";
import { useNuiEvent } from "@/hooks/useNuiEvent";
import { debugData } from "@/utils/debugData";
import type { Plant } from "@/types/plant";
import PlantCard from "@/components/plantCard";


function App() {
  const [visible, setVisibility] = useState<boolean>(true); // fejlesztéshez maradhat true
  const [plant, setPlant] = useState<Plant | null>(null);

  useNuiEvent("open", () => setVisibility(true));
  useNuiEvent("close", () => setVisibility(false));


  useNuiEvent<Plant>("sendPlantData", (data) => {
    setPlant(data);
  });

  useEffect(() => {
    debugData<Plant>([
      {
        action: "sendPlantData",
        data: { name: "Aloe", water: 50, health: 88, stage: 3, maxstage: 5},
      },
    ]);
  }, []);

  return (
    <div className="App">
      {visible && (
        <div>
          {plant ? (
              <PlantCard plant={plant} />
            ) : (
              <p className="text-center text-gray-400">Várakozás debug adatra…</p>
            )}
        </div>
      )}
    </div>
  );
}

export default App;
