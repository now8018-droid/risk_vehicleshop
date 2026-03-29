import { svgTestDrive, svgCash, svgCard, svgCategory, svgCar } from './svgs.js'

let resourceName = "scriptname"
if (typeof GetParentResourceName === "function") {
    resourceName = GetParentResourceName()
}

let currentStats = {
    speed: 0,
    mass: 0,
    brake: 0,
    seats: 0,
    fuelType: "",
    speedPercent: 0,
    weightPercent: 0,
    brakePercent: 0,
    seatsPercent: 0,
    speedUnit: "",
    massUnit: ""
}
let currentPrice = 0
let currentVehicle = { spawnName: "", price: 0 }
let isUiOpen = false

const primaryColorData = [
    { r: 255, g: 255, b: 246 },
    { r: 13, g: 17, b: 22 },
    { r: 29, g: 33, b: 41 },
    { r: 218, g: 25, b: 24 },
    { r: 242, g: 31, b: 153 },
    { r: 223, g: 88, b: 145 },
    { r: 98, g: 18, b: 118 },
    { r: 47, g: 45, b: 82 },
    { r: 35, g: 84, b: 161 },
    { r: 34, g: 46, b: 70 },
    { r: 18, g: 56, b: 60 },
    { r: 152, g: 210, b: 35 },
    { r: 194, g: 148, b: 79 },
    { r: 247, g: 134, b: 22 },
    { r: 253, g: 214, b: 205 },
    { r: 212, g: 74, b: 23 },
    { r: 251, g: 226, b: 18 },
    { r: 58, g: 42, b: 27 }
]

const secondaryColorData = [...primaryColorData]

function rgbToHex(r, g, b) {
    return "#" + [r, g, b].map(x => {
        const hex = x.toString(16)
        return hex.length === 1 ? "0" + hex : hex
    }).join("")
}

function setCircleFill(circleIndex, fill) {
    if (fill < 0) fill = 0
    if (fill > 100) fill = 100
    let maxDash = 350
    let dash = (fill / 100) * maxDash
    let circle = $(".vehicle-info-flex").eq(circleIndex).find(".innercircle")
    circle.css("stroke-dasharray", dash + ",500")
}

function animateNumber(startVal, endVal, duration, callback) {
    const steps = 20
    let stepTime = duration / steps
    let current = startVal
    let increment = (endVal - startVal) / steps
    let count = 0
    let timer = setInterval(() => {
        count++
        current += increment
        callback(Math.round(current))
        if (count >= steps) {
            clearInterval(timer)
            callback(endVal)
        }
    }, stepTime)
}

function animateStatValue(circleIndex, oldVal, newVal, oldPercent, newPercent) {
    animateNumber(oldVal, newVal, 500, val => {
        $(".vehicle-info-flex").eq(circleIndex).find(".vehicle-info-percent").text(val)
    })
    const steps = 20
    let stepTime = 500 / steps
    let cVal = oldPercent
    let cInc = (newPercent - oldPercent) / steps
    let count = 0
    let t = setInterval(() => {
        count++
        cVal += cInc
        setCircleFill(circleIndex, cVal)
        if (count >= steps) {
            clearInterval(t)
            setCircleFill(circleIndex, newPercent)
        }
    }, stepTime)
}

function animateStats(oldS, newS) {
    animateStatValue(0, oldS.speed, newS.speed, oldS.speedPercent, newS.speedPercent)
    animateStatValue(1, oldS.mass, newS.mass, oldS.weightPercent, newS.weightPercent)
    animateStatValue(2, oldS.brake, newS.brake, oldS.brakePercent, newS.brakePercent)
    $(".vehicle-info-flex").eq(3).find(".vehicle-info-percent").text(newS.fuelType)
    animateStatValue(4, oldS.seats, newS.seats, oldS.seatsPercent, newS.seatsPercent)
}

function animatePriceChange(oldP, newP) {
    animateNumber(oldP, newP, 500, val => {
        $("#main-price").text(val.toLocaleString())
    })
}

$(document).ready(function () {
    $("#shopContainer").attr("tabindex", "1")
    buildColorPickers()
    window.addEventListener("message", (event) => {
        let data = event.data
        if (data.action === "openUI") {
            isUiOpen = true
            $("#shopContainer").show()
            $("#shopContainer").focus()
            $("#searchInput").val("").trigger("input")
            $("#searchInput").blur()
            window.focus()
            document.body.focus()
            currentStats = {
                speed: 0,
                mass: 0,
                brake: 0,
                seats: 0,
                fuelType: "",
                speedPercent: 0,
                weightPercent: 0,
                brakePercent: 0,
                seatsPercent: 0,
                speedUnit: "",
                massUnit: ""
            }
            setCircleFill(0, 0)
            $(".vehicle-info-flex").eq(0).find(".vehicle-info-percent").text("0")
            setCircleFill(1, 0)
            $(".vehicle-info-flex").eq(1).find(".vehicle-info-percent").text("0")
            setCircleFill(2, 0)
            $(".vehicle-info-flex").eq(2).find(".vehicle-info-percent").text("0")
            $(".vehicle-info-flex").eq(3).find(".vehicle-info-percent").text("")
            setCircleFill(4, 0)
            $(".vehicle-info-flex").eq(4).find(".vehicle-info-percent").text("0")
            buildCategories(data.categories)
            loadVehicles(0, data.categories)
            $("#car-list-amount").text(data.categories[0].vehicles.length)
            $("#main-category").text(data.categories[0].name.toUpperCase())
            if (data.categories[0].vehicles.length > 0) {
                let newPrice = data.categories[0].vehicles[0].price
                currentVehicle = {
                    spawnName: data.categories[0].vehicles[0].spawnName,
                    price: newPrice
                }
                $("#main-brand").text(data.categories[0].vehicles[0].displayName)
                $("#main-model").text("")
                animatePriceChange(currentPrice, newPrice)
                setTimeout(() => { currentPrice = newPrice }, 500)
            } else {
                animatePriceChange(currentPrice, 0)
                setTimeout(() => { currentPrice = 0 }, 500)
                $("#main-brand").text("")
                $("#main-model").text("")
            }
        }
        if (data.action === "closeUI") {
            isUiOpen = false
            $("#shopContainer").hide()
        }
        if (data.action === "showTestDriveUI") {
            if (data.vehicleName) {
                $("#vehicleName").text(data.vehicleName)
            }
            $("#testDriveUI").show()
        }
        if (data.action === "hideTestDriveUI") {
            $("#testDriveUI").hide()
        }
        if (data.action === "testDriveTimer") {
            let t = data.timeLeft
            if (t < 0) t = 0
            $("#testDriveTimer").text(t + "s")
        }
        if (data.action === "updateStats") {
            let newS = {
                speed: data.speed || 0,
                mass: data.mass || 0,
                brake: data.brake || 0,
                seats: data.seats || 0,
                fuelType: data.fuelType || "",
                speedPercent: data.speedPercent || 0,
                weightPercent: data.weightPercent || 0,
                brakePercent: data.brakePercent || 0,
                seatsPercent: data.seatsPercent || 0,
                speedUnit: data.speedUnit || "",
                massUnit: data.massUnit || ""
            }
            $(".vehicle-info-flex").eq(0).find(".vehicle-info-percent-sign").text(" " + newS.speedUnit)
            $(".vehicle-info-flex").eq(1).find(".vehicle-info-percent-sign").text(" " + newS.massUnit)
            $(".vehicle-info-flex").eq(2).find(".vehicle-info-percent-sign").text("%")
            $(".vehicle-info-flex").eq(3).find(".vehicle-info-percent-sign").text("")
            $(".vehicle-info-flex").eq(4).find(".vehicle-info-percent-sign").text(" seats")
            if (data.skipAnimation) {
                setCircleFill(0, newS.speedPercent)
                $(".vehicle-info-flex").eq(0).find(".vehicle-info-percent").text(newS.speed)
                setCircleFill(1, newS.weightPercent)
                $(".vehicle-info-flex").eq(1).find(".vehicle-info-percent").text(newS.mass)
                setCircleFill(2, newS.brakePercent)
                $(".vehicle-info-flex").eq(2).find(".vehicle-info-percent").text(newS.brake)
                $(".vehicle-info-flex").eq(3).find(".vehicle-info-percent").text(newS.fuelType)
                setCircleFill(4, newS.seatsPercent)
                $(".vehicle-info-flex").eq(4).find(".vehicle-info-percent").text(newS.seats)
                currentStats = newS
            } else {
                animateStats(currentStats, newS)
                setTimeout(() => {
                    currentStats = newS
                }, 500)
            }
        }
    })

    // helper: UI schließen
    const triggerClose = () => {
        $.post(`https://${resourceName}/close`, JSON.stringify({}))
    };

    // ESC früh abfangen (keydown, capture)
    window.addEventListener('keydown', (e) => {
        if (!isUiOpen) return
        if (e.key === 'Escape') {
            e.preventDefault()
            e.stopPropagation()
            if (document.activeElement) document.activeElement.blur()
            triggerClose()
        }
    }, true)

    // Globaler Key-Blocker – ESC zuerst behandeln!
    const isTypingTarget = (el) =>
        el && (el.tagName === 'INPUT' || el.tagName === 'TEXTAREA' || el.isContentEditable)

        ;['keydown', 'keypress', 'keyup'].forEach(type => {
            window.addEventListener(type, (e) => {
                if (!isUiOpen) return

                // ESC immer erlauben & schließen
                if (e.key === 'Escape') {
                    e.preventDefault()
                    e.stopPropagation()
                    triggerClose()
                    return
                }

                // Eingabefelder: Events nicht nach draußen lassen (Chat/F3/T etc.)
                const t = e.target
                if (isTypingTarget(t)) {
                    e.stopImmediatePropagation()
                    e.stopPropagation()
                    return
                }

                // alle anderen Tasten komplett schlucken
                e.preventDefault()
                e.stopImmediatePropagation()
                e.stopPropagation()
            }, true)
        })


    $(".btn-test-drive").prepend(svgTestDrive)
    $(".btn-cash").prepend(svgCash)
    $(".btn-card").prepend(svgCard)
    $(".btn-test-drive").click(() => {
        $.post(`https://${resourceName}/testDrive`)
    })
    $(".btn-cash").click(() => {
        $.post(`https://${resourceName}/buyVehicle`, JSON.stringify({
            payType: "cash",
            spawnName: currentVehicle.spawnName,
            price: currentVehicle.price
        }))
    })
    $(".btn-card").click(() => {
        $.post(`https://${resourceName}/buyVehicle`, JSON.stringify({
            payType: "bank",
            spawnName: currentVehicle.spawnName,
            price: currentVehicle.price
        }))
    })
    $("#searchInput").on("input", function () {
        let val = $(this).val().toLowerCase()
        $(".box-car").each(function () {
            let txt = $(this).find(".title2-car").text().toLowerCase()
            if (txt.indexOf(val) !== -1) {
                $(this).show()
            } else {
                $(this).hide()
            }
        })
    })
})

function buildColorPickers() {
    let primaryContainer = $(".colors1-flex")
    let secondaryContainer = $(".colors2-flex")
    primaryContainer.empty()
    secondaryContainer.empty()
    primaryColorData.forEach((col, i) => {
        let index = i + 1
        let divId = `color1-${index}`
        let hex = rgbToHex(col.r, col.g, col.b)
        let div = (
            `<div
              id="${divId}"
              class="color1"
              data-r="${col.r}"
              data-g="${col.g}"
              data-b="${col.b}"
              style="background:${hex}"
            ></div>`
        )
        primaryContainer.append(div)
    })
    secondaryColorData.forEach((col, i) => {
        let index = i + 1
        let divId = `color2-${index}`
        let hex = rgbToHex(col.r, col.g, col.b)
        let div = (
            `<div
              id="${divId}"
              class="color2"
              data-r="${col.r}"
              data-g="${col.g}"
              data-b="${col.b}"
              style="background:${hex}"
            ></div>`
        )
        secondaryContainer.append(div)
    })
    $(".color1").click(function () {
        $(".color1").removeClass("active")
        $(this).addClass("active")
        let r = $(this).data("r")
        let g = $(this).data("g")
        let b = $(this).data("b")
        $.post(`https://${resourceName}/setColor`, JSON.stringify({
            type: "primary", r, g, b
        }))
    })
    $(".color2").click(function () {
        $(".color2").removeClass("active")
        $(this).addClass("active")
        let r = $(this).data("r")
        let g = $(this).data("g")
        let b = $(this).data("b")
        $.post(`https://${resourceName}/setColor`, JSON.stringify({
            type: "secondary", r, g, b
        }))
    })
}

function buildCategories(categories) {
    $("#categoriesContainer").empty()
    $.each(categories, (i, cat) => {
        let catDiv = (
            `<div class="box-category" data-catindex="${i}">
                <p class="category-name">${cat.name}</p>
            </div>`
        )
        $("#categoriesContainer").append(catDiv)
    })
    $(".box-category").each((idx, el) => {
        $(el).css({
            'opacity': '0',
            'animation': 'fadeInCar 0.6s ease forwards',
            'animation-delay': (0.1 * idx) + 's'
        })
    })
    $(".box-category").each(function () {
        $(this).prepend(svgCategory)
    })
    $(".box-category").click(function () {
        $(".box-category").removeClass("box-category-active")
        $(this).addClass("box-category-active")
        let i = $(this).data("catindex")
        $.post(`https://${resourceName}/null`, JSON.stringify({ catIndex: i, vehIndex: 0 }))
        loadVehicles(i, categories)
        $("#car-list-amount").text(categories[i].vehicles.length)
        $("#main-category").text(categories[i].name.toUpperCase())
        if (categories[i].vehicles.length > 0) {
            let newPrice = categories[i].vehicles[0].price
            currentVehicle = {
                spawnName: categories[i].vehicles[0].spawnName,
                price: newPrice
            }
            $("#main-brand").text(categories[i].vehicles[0].displayName)
            $("#main-model").text("")
            animatePriceChange(currentPrice, newPrice)
            setTimeout(() => { currentPrice = newPrice }, 500)
        } else {
            animatePriceChange(currentPrice, 0)
            setTimeout(() => { currentPrice = 0 }, 500)
            currentVehicle = { spawnName: "", price: 0 }
            $("#main-brand").text("")
            $("#main-model").text("")
        }
    })
    $(".box-category").first().addClass("box-category-active")
}

function loadVehicles(catIndex, categories) {
    $("#carsContainer").empty()
    let vehicles = categories[catIndex].vehicles
    $.each(vehicles, (index, veh) => {
        let hasImage = (veh.image && veh.image !== "")
        let html = (
            `<div class="box-car" data-vehindex="${index}" data-catindex="${catIndex}">
                <div class="line-car"></div>
                ${hasImage
                ? `<img class="car-icn-real" src="../html/assets/img/cars/${veh.image}" onerror="this.style.display='none';this.nextElementSibling.style.display='block';">`
                : ``
            }
                <svg class="car-icn" style="display:${hasImage ? 'none' : 'block'};" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 53 19">
                    <path fill-rule="evenodd" clip-rule="evenodd" d="M48.0535 16.2243C49.0351 16.1357 52.3832 15.7621 52.8581 14.7585C53.4156 13.5804 52.2075 7.81415 51.3616 7.62828C50.5158 7.44231 39.91 5.64415 38.4786 5.1481C37.0471 4.65214 29.6947 0.125877 28.2631 0.125877C26.8316 0.125877 6.01047 -0.308223 5.29463 0.435862C4.5788 1.17995 6.07549 1.36592 6.07549 1.36592C6.07549 1.36592 1.0654 4.34205 1.0654 5.08604C1.0654 5.83002 1.93674 10.5423 0.935261 10.5423C-0.0662193 10.5423 -0.561214 13.2705 1.00027 14.2624C2.56187 15.2545 5.55492 15.1924 5.94534 15.1924C5.96017 15.1924 6.02594 15.1932 6.12879 15.1946C6.12008 15.0813 6.11546 14.9667 6.11546 14.8512C6.11546 12.3002 8.28564 10.2321 10.9627 10.2321C13.6399 10.2321 15.8101 12.3002 15.8101 14.8512C15.8101 15.0157 15.8009 15.1782 15.7834 15.3384C24.8668 15.4756 37.1741 15.6636 38.6553 15.6861C38.6035 15.4153 38.5762 15.1363 38.5762 14.8512C38.5762 12.3002 40.7464 10.2321 43.4235 10.2321C46.1007 10.2321 48.2709 12.3002 48.2709 14.8512C48.2711 15.3295 48.1949 15.7907 48.0535 16.2243ZM12.3393 5.44661C13.1778 5.44661 13.8576 5.63176 13.8576 5.86002C13.8576 6.08829 13.1778 6.27334 12.3393 6.27334C11.5008 6.27334 10.8211 6.08829 10.8211 5.86002C10.8211 5.63176 11.5009 5.44661 12.3393 5.44661ZM25.8948 6.37666C26.7333 6.37666 27.4131 6.56182 27.4131 6.78998C27.4131 7.01824 26.7333 7.20339 25.8948 7.20339C25.0563 7.20339 24.3766 7.01824 24.3766 6.78998C24.3766 6.56182 25.0563 6.37666 25.8948 6.37666ZM37.1217 12.9896C37.1217 12.9896 37.2301 13.6612 36.959 13.8163C36.6879 13.9713 36.4168 12.9896 35.6035 12.5763C34.7901 12.1629 20.9636 12.2146 18.9574 12.1629C16.9511 12.1112 17.1139 13.5063 16.7884 12.8346C16.4631 12.1629 17.1138 10.5096 17.3849 10.1996C17.6561 9.88962 29.2594 10.2513 33.4889 10.5612C37.7181 10.8712 37.1217 12.9896 37.1217 12.9896ZM51.1016 11.2553C51.1016 11.2553 52.6956 11.4413 52.598 12.2164C52.5005 12.9915 51.3618 12.6195 51.1016 12.4644C50.8413 12.3094 51.1016 11.2553 51.1016 11.2553ZM45.701 7.13222C45.701 7.13222 50.6786 8.12423 51.1016 8.3102C51.5245 8.49627 51.7847 8.99233 51.3618 9.3953C50.9389 9.79827 48.141 9.14727 45.701 7.13222ZM0.675079 11.6275C0.675079 11.6275 2.33426 11.5344 2.10654 12.1854C1.87881 12.8364 0.623817 12.9806 0.382236 13.0535C0.140865 13.1265 0.268856 11.0447 0.675079 11.6275ZM1.78123 5.42726C1.78123 5.42726 6.75876 5.30334 7.05161 5.45828C7.34445 5.61333 2.56208 7.93847 2.17166 7.87641C1.78123 7.81425 1.78123 5.42726 1.78123 5.42726ZM36.917 5.64415C38.4318 6.52055 28.3882 5.76827 23.2384 5.38281V1.04016C25.2763 1.046 26.8801 1.05604 27.4175 1.05604C29.3044 1.05604 36.917 5.64415 36.917 5.64415ZM22.2622 1.03781V5.31C21.6676 5.26596 21.1812 5.23104 20.8456 5.21015C17.8525 5.02418 11.9966 3.59807 10.8904 3.22603C9.78426 2.85409 8.80825 1.676 9.65412 1.30396C10.222 1.05429 17.1777 1.02808 22.2622 1.03781Z"/>
                    <path fill-rule="evenodd" clip-rule="evenodd" d="M43.4237 10.7028C41.0194 10.7028 39.0703 12.5602 39.0703 14.8514C39.0703 17.1426 41.0194 19 43.4237 19C45.8282 19 47.7774 17.1426 47.7774 14.8514C47.7773 12.5602 45.8282 10.7028 43.4237 10.7028ZM43.4237 11.6984C43.4647 11.6984 43.5053 11.6994 43.5458 11.7008V14.1919H44.0262L44.1734 14.4457L46.2692 13.2418C46.3121 13.3105 46.3523 13.3808 46.3898 13.4528L44.2954 14.6559L44.5195 15.0421L44.1488 15.411L45.7957 17.0495C45.7378 17.1063 45.6776 17.161 45.6154 17.2134L43.9763 15.5826L43.5161 16.0404L45.0705 17.587C44.5857 17.8526 44.0234 18.0046 43.4238 18.0046C42.8244 18.0046 42.262 17.8526 41.7772 17.587L43.3315 16.0404L42.8715 15.5826L41.2324 17.2134C41.1702 17.161 41.11 17.1063 41.052 17.0495L42.699 15.411L42.3283 15.0421L42.5524 14.6559L40.458 13.4528C40.4955 13.381 40.5358 13.3105 40.5787 13.2418L42.6744 14.4457L42.8217 14.1919H43.302V11.7008C43.3423 11.6994 43.3829 11.6984 43.4237 11.6984ZM42.651 13.6849L40.9807 12.7254C41.4193 12.268 41.9974 11.9341 42.651 11.7851V13.6849ZM40.2193 14.0634L42.0664 15.1244L40.635 16.5486C40.3058 16.0587 40.1149 15.4763 40.1149 14.8514C40.1149 14.5793 40.1513 14.3153 40.2193 14.0634ZM45.8668 12.7254L44.1964 13.6849V11.7851C44.85 11.9342 45.4282 12.2679 45.8668 12.7254ZM44.781 15.1244L46.6282 14.0634C46.6962 14.3153 46.7325 14.5793 46.7325 14.8514C46.7325 15.4764 46.5417 16.0587 46.2124 16.5486L44.781 15.1244Z"/>
                    <path fill-rule="evenodd" clip-rule="evenodd" d="M10.963 10.7028C8.5585 10.7028 6.60927 12.5602 6.60927 14.8514C6.60927 17.1426 8.5585 19 10.963 19C13.3673 19 15.3165 17.1426 15.3165 14.8514C15.3165 12.5602 13.3673 10.7028 10.963 10.7028ZM10.963 11.6984C11.0038 11.6984 11.0444 11.6994 11.0849 11.7008V14.1919H11.5653L11.7125 14.4457L13.8082 13.2418C13.8511 13.3105 13.8913 13.3808 13.9288 13.4528L11.8344 14.6559L12.0585 15.0421L11.6878 15.411L13.3347 17.0495C13.2768 17.1063 13.2166 17.161 13.1544 17.2134L11.5153 15.5826L11.0553 16.0404L12.6096 17.587C12.1247 17.8526 11.5624 18.0046 10.963 18.0046C10.3634 18.0046 9.80103 17.8526 9.31614 17.587L10.8705 16.0404L10.4106 15.5826L8.77139 17.2134C8.70916 17.161 8.64898 17.1063 8.59106 17.0495L10.238 15.411L9.86733 15.0421L10.0914 14.6559L7.99698 13.4528C8.03449 13.381 8.07479 13.3105 8.11767 13.2418L10.2135 14.4457L10.3607 14.1919H10.841V11.7008C10.8814 11.6994 10.922 11.6984 10.963 11.6984ZM10.1903 13.6849L8.51992 12.7254C8.95838 12.268 9.53666 11.9341 10.1903 11.7851V13.6849ZM7.75841 14.0634L9.60554 15.1244L8.17409 16.5486C7.84492 16.0587 7.65406 15.4763 7.65406 14.8514C7.65416 14.5793 7.69049 14.3153 7.75841 14.0634ZM13.4059 12.7254L11.7355 13.6849V11.7851C12.3891 11.9342 12.9673 12.2679 13.4059 12.7254ZM12.3202 15.1244L14.1674 14.0634C14.2354 14.3153 14.2717 14.5793 14.2717 14.8514C14.2717 15.4764 14.0809 16.0587 13.7517 16.5486L12.3202 15.1244Z"/>
                </svg>
                <div class="box-car-cnt">
                    <div class="car-cnt-title-flex">
                        <p class="title1-car">${categories[catIndex].name}</p>
                        <p class="title2-car">${veh.displayName}</p>
                    </div>
                    <div class="car-price-flex">
                        <div class="line-price"></div>
                        <div class="box-car-price">
                            <p class="dollar-car-price">$</p>
                            <p class="amount-car-price">${veh.price.toLocaleString()}</p>
                        </div>
                    </div>
                </div>
            </div>`
        )
        $("#carsContainer").append(html)
    })
    $(".box-car").each(function (idx) {
        $(this).css({
            'opacity': '0',
            'animation': 'fadeInCar 0.6s ease forwards',
            'animation-delay': (0.1 * idx) + 's'
        })
    })
    $(".box-car").each(function () {
        $(this).prepend(svgCar)
    })
    $(".box-car").click(function () {
        $(".box-car").removeClass("box-car-active")
        $(this).addClass("box-car-active")
        let cIndex = $(this).data("catindex")
        let vIndex = $(this).data("vehindex")
        let veh = categories[cIndex].vehicles[vIndex]
        $("#main-category").text(categories[cIndex].name.toUpperCase())
        $("#main-brand").text(veh.displayName)
        $("#main-model").text("")
        animatePriceChange(currentPrice, veh.price)
        setTimeout(() => { currentPrice = veh.price }, 500)
        currentVehicle = {
            spawnName: veh.spawnName,
            price: veh.price
        }
        $.post(`https://${resourceName}/null`, JSON.stringify({
            catIndex: cIndex,
            vehIndex: vIndex
        }))
    })
    if (vehicles.length > 0) {
        $(".box-car").first().addClass("box-car-active")
    }
}


let rotating = false
let lastX = 0


document.addEventListener('mousedown', (e) => {
    if (!isUiOpen) return
    if (e.button === 0) {
        rotating = true
        lastX = e.clientX
        e.preventDefault()
    }
})

document.addEventListener('mouseup', () => {
    rotating = false
})

document.addEventListener('mousemove', (e) => {
    if (!isUiOpen || !rotating) return
    const dx = e.clientX - lastX
    lastX = e.clientX
    $.post(`https://${resourceName}/uiRotate`, JSON.stringify({ dx }))
})


document.addEventListener('wheel', (e) => {
  if (!isUiOpen) return


  const blockZoomSelectors = [
    '#categoriesContainer',   
    '#carsContainer',         
    '#searchInput',           
    '.colors1-flex',          
    '.colors2-flex',          
    '#testDriveUI'            
  ]

  for (const sel of blockZoomSelectors) {
    if (e.target && e.target.closest(sel)) {
      return 
    }
  }


  const zoomArea = document.querySelector('#previewZoomArea')
  if (zoomArea && !e.target.closest('#previewZoomArea')) {
    return 
  }


  $.post(`https://${resourceName}/uiWheel`, JSON.stringify({ delta: e.deltaY }))
  e.preventDefault() 
}, { passive: false })
