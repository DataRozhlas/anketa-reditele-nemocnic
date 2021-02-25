import "./byeie"; // loučíme se s IE
import { h, render, Component } from "preact";
/** @jsx h */

let host = "https://data.irozhlas.cz/anketa-reditele-nemocnic";
if (window.location.hostname === "localhost") {
  host = "http://127.0.0.1:54000";
}

class Container extends Component {
  state = {
    data: this.props.data,
    vybranaData: this.props.data,
  };

  filtrujData = (kraj) => {
    this.setState({
      ...this.state,
      vybranaData: this.state.data.filter((el) => {
        if (kraj === "all") {
          return el;
        } else {
          return el.k === kraj;
        }
      }),
    });
  };

  render(_, { value, data, vybranaData }) {
    return (
      <div>
        <MySelect data={data} filtruj={this.filtrujData}></MySelect>
        <Anketa data={vybranaData}></Anketa>
      </div>
    );
  }
}

class MySelect extends Component {
  state = { value: "all" };

  onChange = (e) => {
    e.preventDefault();
    this.setState({ value: e.target.value });
    this.props.filtruj(e.target.value);
  };

  render(_, {}) {
    const kraje = [...new Set(this.props.data.map((i) => i.k))];
    return (
      <div>
        <label for="selectKraj">Který kraj? </label>
        <select
          id="selectKraj"
          value={this.props.value}
          onChange={this.onChange}
        >
          <option value="all">Všechny</option>
          {kraje.map((kraj) => (
            <option value={kraj}>{kraj}</option>
          ))}
        </select>
      </div>
    );
  }
}

class Anketa extends Component {
  render(_, {}) {
    const qu1 = "1.";
    const qu2 = "2.";
    const qu3 = "3.";

    function printResps(obj) {
      if (obj.o1 === null) {
        obj.o1 = "<i>Bez odpovědi.</i>";
      }
      if (obj.o2 === null) {
        obj.o2 = "<i>Bez odpovědi.</i>";
      }
      if (obj.o3 === null) {
        obj.o3 = "<i>Bez odpovědi.</i>";
      }
      return `<p><b>${qu1}</b> ${obj.o1}</p><p><b>${qu2}</b> ${obj.o2}</p><p><b>${qu3}</b> ${obj.o3}</p>`;
    }

    return (
      <div id="anketa">
        {this.props.data.map((el) => (
          <div className="respondent">
            <img
              className="portret"
              src={host + "/foto/orez/" + el.f}
              alt={el.p}
            />
            <div className="bio">
              <div className="jmeno">{`${el.j} ${el.p}`}</div>
              <div className="vek">{el.n}</div>
            </div>
            <div
              className="odpoved"
              dangerouslySetInnerHTML={{ __html: printResps(el) }}
            ></div>
          </div>
        ))}
      </div>
    );
  }
}

function onLoad(e) {
  const data = JSON.parse(e.target.response);
  render(
    <Container data={data}></Container>,
    document.getElementById("anketa-wrapper")
  );
}

const r = new XMLHttpRequest();
r.addEventListener("load", onLoad);
r.open("GET", host + "/data/data.json");
r.send();
