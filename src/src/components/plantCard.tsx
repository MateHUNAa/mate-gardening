import type { Plant } from "@/types/plant";
import "./plantCard.css";


export default function PlantCard({ plant }: { plant: Plant }) {
  const { name, water, health, stage, maxstage } = plant;

  const imgName = "https://www.seriouseats.com/thmb/1Vl9G52_YL5XdiwK78ylIlQyYfY=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/20240717-BoilingCorn-AmandaSuarez-SEA-f80166320b364edbbea05d65e538e270.jpg";


  const stageNum = Number(stage) || 0;
  const maxStageNum = Number(maxstage) || 0;
  let stagePercent = 0;
  if (maxStageNum > 0 && Number.isFinite(stageNum)) {
    stagePercent = (stageNum / maxStageNum) * 100;
  } else if (maxStageNum === 0 && stageNum > 0) {
  
    stagePercent = 100;
  }

  stagePercent = Math.max(0, Math.min(100, stagePercent));

  return (
    <div className="main">
      <h1 className="tilte">{name}</h1>
      
      <img className="image" src={imgName} alt="" />


      <p className="pFix">Egészség</p>
      <div className="proggresBarOut">
        <div
          className="proggresBar"
          style={{ width: `${Math.max(0, Math.min(100, Number(health) || 0))}%` }}
        ><p className="proggresBarText">{health}<span className="szazalek">%</span></p></div>
      </div>

      
      <p>Víz</p>
      <div className="proggresBarOut">
        <div
          className="proggresBar"
          style={{ width: `${Math.max(0, Math.min(100, Number(water) || 0))}%` }}
        ><p className="proggresBarText">{water}<span className="szazalek">%</span></p></div>
      </div>

      
      <p>Növekedés</p>
      <div className="proggresBarOut">
        <div
          className="specialColor proggresBar"
          style={{ width: `${stagePercent}%` }}
        ><p className="proggresBarText">{stage}/{maxstage}</p></div>
      </div>

      
     

      
    </div>
  );
}
