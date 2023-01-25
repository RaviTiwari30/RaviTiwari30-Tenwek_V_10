<%@ Page Language="C#" AutoEventWireup="true" CodeFile="NewCheckListForm.aspx.cs" Inherits="Design_OT_NewCheckListForm" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Untitled Page</title>
    <link href="../../Styles/framestyle.css" rel="stylesheet" type="text/css" />
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <link href="../../Styles/CustomStyle.css" rel="stylesheet" />
    <script src="../../Scripts/jquery-1.7.1.min.js" type="text/javascript"></script>
    <script type="text/javascript" src="../../Scripts/Message.js"></script>

</head>
<script type="text/javascript">
    $(document).ready(function () {

        EditSurgerySafety();

    });
    function printDiv() {

        var divToPrint = document.getElementById('divSurgerySafety');

        var newWin = window.open('', 'Print-Window');

        newWin.document.open();

        newWin.document.write('<html><body onload="window.print()">' + divToPrint.innerHTML + '</body></html>');

        newWin.document.close();

        setTimeout(function () { newWin.close(); }, 10);

    }


    function SavessclMaster() {

        var tid = $("#Transaction_ID").text();
        if (tid == "") {
            return false;
        }
        var Pid = $("#PatientId").text();
        if (Pid == "") {
            return false;
        }



        var chkHeader1 = $('input[name="chkHeader1"]:checked').val();
        var chkHeader2 = $('input[name="chkHeader2"]:checked').val();
        var chkHeader3 = $('input[name="chkHeader3"]:checked').val();
        var chkHeader4 = $('input[name="chkHeader4"]:checked').val();
        var chkHeader5 = $('input[name="chkHeader5"]:checked').val();
        var chkHeader6 = $('input[name="chkHeader6"]:checked').val();
        var chkHeader7 = $('input[name="chkHeader7"]:checked').val();
        var chkHeader8 = $('input[name="chkHeader8"]:checked').val();
        var chkHeader9 = $('input[name="chkHeader9"]:checked').val();



        var nameh1 = $('input[name="rblnameh1"]:checked').val();
        var sexh1 = $('input[name="rblsexh1"]:checked').val();
        var ageh1 = $('input[name="rblAgeh1"]:checked').val();
        var dobh1 = $('input[name="rbldobh1"]:checked').val();


        var fnh2 = $('input[name="rblFullNameh2"]:checked').val();
        var sexh2 = $('input[name="rblsexh2"]:checked').val();
        var ageh2 = $('input[name="rblAgeh2"]:checked').val();
        var surh2 = $('input[name="rblsurh2"]:checked').val();
        var Digh2 = $('input[name="rblDigh2"]:checked').val();
        var mrnoh2 = $('input[name="rblMrNoh2"]:checked').val();




        var With4 = $('input[name="rblwitnessh4"]:checked').val();
        var Oprh4 = $('input[name="rblOprh4"]:checked').val();


        var rblRingh9 = $('input[name="rblRingh9"]:checked').val();
        var rblBeadsh9 = $('input[name="rblBeadsh9"]:checked').val();
        var rblHph9 = $('input[name="rblHph9"]:checked').val();
        var rblHegh9 = $('input[name="rblegh9"]:checked').val();
        var rblRMh9 = $('input[name="rblRMh9"]:checked').val();
        var rblHAh9 = $('input[name="rblHAh9"]:checked').val();
        var rblMonh9 = $('input[name="rblMonh9"]:checked').val();
        var rblWigh9 = $('input[name="rblWigh9"]:checked').val();
        var rblwwh9 = $('input[name="rblwwh9"]:checked').val();

        var rblUgh9 = $('input[name="rblUgh9"]:checked').val();
        var rblAeh9 = $('input[name="rblAeh9"]:checked').val();




        var _PatientId = Pid;
        var _TransactionId = tid;


        var data = {

            "Pid": _PatientId,
            "Tid": _TransactionId,
            "H1": chkHeader1,
            "H2": chkHeader2,
            "H3": chkHeader3,
            "H4": chkHeader4,
            "H5": chkHeader5,
            "H6": chkHeader6,
            "H7": chkHeader7,
            "H8": chkHeader8,
            "H9": chkHeader9,

            "NameH1": nameh1,
            "AgeH1": ageh1,
            "SexH1": sexh1,
            "DobH1": dobh1,


            "FullNameH2": fnh2,
            "AgeH2": ageh2,
            "SexH2": sexh2,
            "MrNoH2": rblMonh9,
            "DigH2": Digh2,
            "SurH2": surh2,

            "WitH4": With4,
            "OprH4": Oprh4,

            "RingH9": rblRingh9,
            "BeadsH9": rblBeadsh9,
            "HpH9": rblHph9,
            "EgH9": rblHegh9,
            "RmH9": rblRMh9,
            "Ha9": rblHAh9,
            "MonH9": rblMonh9,
            "WWH9": rblwwh9,
            "WigH9": rblWigh9,
            "UgH9": rblUgh9,
            "AeH9": rblAeh9,


        };

        serverCall('NewCheckListForm.aspx/SavessclTransaction', { sscldata: data }, function (response) {

            var $responseData = JSON.parse(response);

            if ($responseData.status) {


                modelAlert($responseData.response)


            }


        });




    }


    function EditSurgerySafety() {
        var tid = $("#Transaction_ID").text();
        if (tid == "") {
            return false;
        }

        serverCall('NewCheckListForm.aspx/EditSurgerySafety', { Tid: tid }, function (response) {
            var data= JSON.parse(response)
            if (data.status) {
                var responseData =data.response;

            $("input[name='chkHeader1").each(function () {
                if ($(this).val() == responseData[0]["h1"]) {
                    $(this).attr("checked", "checked");
                }
            });
            $("input[name='chkHeader2").each(function () {
                if ($(this).val() == responseData[0]["h2"]) {
                    $(this).attr("checked", "checked");
                }
            });

            $("input[name='chkHeader3").each(function () {
                if ($(this).val() == responseData[0]["h3"]) {
                    $(this).attr("checked", "checked");
                }
            });

            $("input[name='chkHeader4").each(function () {
                if ($(this).val() == responseData[0]["h4"]) {
                    $(this).attr("checked", "checked");
                }
            });
            $("input[name='chkHeader5").each(function () {
                if ($(this).val() == responseData[0]["h5"]) {
                    $(this).attr("checked", "checked");
                }
            });
            $("input[name='chkHeader6").each(function () {
                if ($(this).val() == responseData[0]["h6"]) {
                    $(this).attr("checked", "checked");
                }
            });

            $("input[name='chkHeader7").each(function () {
                if ($(this).val() == responseData[0]["h7"]) {
                    $(this).attr("checked", "checked");
                }
            });


            $("input[name='chkHeader8").each(function () {
                if ($(this).val() == responseData[0]["h8"]) {
                    $(this).attr("checked", "checked");
                }
            });

            $("input[name='chkHeader9").each(function () {
                if ($(this).val() == responseData[0]["h9"]) {
                    $(this).attr("checked", "checked");
                }
            });




            $("input[name='rblnameh1").each(function () {
                if ($(this).val() == responseData[0]["nameh1"]) {
                    $(this).attr("checked", "checked");
                }
            });



            $("input[name='rblsexh1").each(function () {
                if ($(this).val() == responseData[0]["sexh1"]) {
                    $(this).attr("checked", "checked");
                }
            });
            $("input[name='rblAgeh1").each(function () {
                if ($(this).val() == responseData[0]["ageh1"]) {
                    $(this).attr("checked", "checked");
                }
            });
            $("input[name='rbldobh1").each(function () {
                if ($(this).val() == responseData[0]["dobh1"]) {
                    $(this).attr("checked", "checked");
                }
            });

            $("input[name='rblFullNameh2").each(function () {
                if ($(this).val() == responseData[0]["fullNameh2"]) {
                    $(this).attr("checked", "checked");
                }
            });
            $("input[name='rblsexh2").each(function () {
                if ($(this).val() == responseData[0]["sexh2"]) {
                    $(this).attr("checked", "checked");
                }
            });
            $("input[name='rblAgeh2").each(function () {
                if ($(this).val() == responseData[0]["ageh2"]) {
                    $(this).attr("checked", "checked");
                }
            });
            $("input[name='rblsurh2").each(function () {
                if ($(this).val() == responseData[0]["surh2"]) {
                    $(this).attr("checked", "checked");
                }
            });


            $("input[name='rblDigh2").each(function () {
                if ($(this).val() == responseData[0]["digh2"]) {
                    $(this).attr("checked", "checked");
                }
            }); $("input[name='rblMrNoh2").each(function () {
                if ($(this).val() == responseData[0]["mrnoh2"]) {
                    $(this).attr("checked", "checked");
                }
            });





            $("input[name='rblwitnessh4").each(function () {
                if ($(this).val() == responseData[0]["With4"]) {
                    $(this).attr("checked", "checked");
                }
            });

            $("input[name='rblOprh4").each(function () {
                if ($(this).val() == responseData[0]["oprh4"]) {
                    $(this).attr("checked", "checked");
                }
            });





            $("input[name='rblRingh9").each(function () {
                if ($(this).val() == responseData[0]["ringh9"]) {
                    $(this).attr("checked", "checked");
                }
            });
            $("input[name='rblBeadsh9").each(function () {
                if ($(this).val() == responseData[0]["basedh9"]) {
                    $(this).attr("checked", "checked");
                }
            });

            $("input[name='rblHph9").each(function () {
                if ($(this).val() == responseData[0]["hph9"]) {
                    $(this).attr("checked", "checked");
                    $(this).removeAttr("disabled");
                }
            });
            $("input[name='rblegh9").each(function () {
                if ($(this).val() == responseData[0]["egh9"]) {
                    $(this).attr("checked", "checked");
                    $('#txtactualproce').removeAttr('disabled');
                }
            });
            $("input[name='rblRMh9").each(function () {
                if ($(this).val() == responseData[0]["rmh9"]) {
                    $(this).attr("checked", "checked");
                }
            });

            $("input[name='rblHAh9").each(function () {
                if ($(this).val() == responseData[0]["hah9"]) {
                    $(this).attr("checked", "checked");
                }
            });
            $("input[name='rblMonh9").each(function () {
                if ($(this).val() == responseData[0]["monh9"]) {
                    $(this).attr("checked", "checked");
                }
            });
            $("input[name='rblRMh9").each(function () {
                if ($(this).val() == responseData[0]["rmh9"]) {
                    $(this).attr("checked", "checked");
                }
            });


            $("input[name='rblWigh9").each(function () {
                if ($(this).val() == responseData[0]["wigh9"]) {
                    $(this).attr("checked", "checked");
                }
            });
            $("input[name='rblwwh9").each(function () {
                if ($(this).val() == responseData[0]["wwh9"]) {
                    $(this).attr("checked", "checked");
                }
            });
            $("input[name='rblUgh9").each(function () {
                if ($(this).val() == responseData[0]["ugh9"]) {
                    $(this).attr("checked", "checked");
                }
            });
            $("input[name='rblAeh9").each(function () {
                if ($(this).val() == responseData[0]["aeh9"]) {
                    $(this).attr("checked", "checked");
                }
            });

            var Txtval = $("#<%=App_ID.ClientID%>").text();
            if (Txtval == "PrintOtForm") {
                printDiv();
            }

          }
        });

    }


</script>
<body>
    <%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
    <%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>
    <form id="form1" runat="server">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server">
        </Ajax:ScriptManager>
        <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        <asp:Label ID="Transaction_ID" runat="server" Style="display: none" />
        <asp:Label ID="PatientId" runat="server" Style="display: none" />
        <asp:Label ID="App_ID" runat="server" Style="display: none" />
        <asp:Label ID="OTBookingID" runat="server" Style="display: none" />
        <asp:Label ID="OTNumber" runat="server" Style="display: none" />
        <input id="txtcount" value="" style="display: none" />

        <div class="POuter_Box_Inventory">
           
            <div id="divSurgerySafety">
                <div class="Purchaseheader" onclick="togglehideshow(4)">
                    <center><b>Ward Check List for Surgery </b></center>
                </div>
                <div class="POuter_Box_Inventory">
                    <center><b>IPD No:<asp:Label ID="lblIpdNo" runat="server" Style="font-size: 14px" /></b> </center>
                </div>

                <div id="divappendSurgerychecklist">
                    <div class="row">
                        <label class="pull-left">
                            <u><b>
                                <input type="checkbox" id="chkHeader1" name="chkHeader1" class="pull-left" value="1">A. Identification of the patient (Wrist band) </b></u>
                        </label>
                    </div>
                    <div class="row" style="margin-left: 20px;">
                        <label class="pull-left ">1.Name</label>
                    </div>
                    <div class="row" style="margin-left: 30px;">
                        <div class="col-md-3">
                            <input type="radio" id="rblNameYh1" name="rblnameh1" class="pull-left" value="1">
                            <label class="pull-left " for="rblNameh1">Yes</label>
                            <input type="radio" id="rblNameNh1" name="rblnameh1" class="pull-left" value="2">
                            <label class="pull-left" for="rblNameNh1">No</label>


                        </div>

                    </div>
                    <div class="row" style="margin-left: 20px;">
                        <label class="pull-left ">2.Sex</label>
                    </div>
                    <div class="row" style="margin-left: 30px;">
                        <div class="col-md-3">
                            <input type="radio" id="rblSexYh1" name="rblsexh1" class="pull-left" value="1">
                            <label class="pull-left " for="rblSexYh1">Yes</label>
                            <input type="radio" id="rblSexNh1" name="rblsexh1" class="pull-left" value="2">
                            <label class="pull-left" for="rblSexNh1">No</label>

                        </div>

                    </div>
                    <div class="row" style="margin-left: 20px;">
                        <label class="pull-left ">3.Age</label>
                    </div>
                    <div class="row" style="margin-left: 30px;">
                        <div class="col-md-3">
                            <input type="radio" id="rblAgeYh1" name="rblAgeh1" class="pull-left" value="1">
                            <label class="pull-left " for="rblAgeYh1">Yes</label>
                            <input type="radio" id="rblAgeNh1" name="rblAgeh1" class="pull-left" value="2">
                            <label class="pull-left" for="rblAgeNh1">No</label>

                        </div>

                    </div>
                    <div class="row" style="margin-left: 20px;">
                        <label class="pull-left ">4.DOB</label>
                    </div>
                    <div class="row" style="margin-left: 30px;">
                        <div class="col-md-3">
                            <input type="radio" id="rbldobYh1" name="rbldobh1" class="pull-left" value="1">
                            <label class="pull-left " for="rbldobYh1">Yes</label>
                            <input type="radio" id="rbldobNh1" name="rbldobh1" class="pull-left" value="2">
                            <label class="pull-left" for="rbldobNh1">No</label>

                        </div>

                    </div>

                    <div class="row">
                        <label class="pull-left">
                            <u>
                                <input type="checkbox" id="chkHeader2" name="chkHeader2" class="pull-left" value="1"><b>B. To Verify Accuraccy,Allow Patient to Pronounce or Spell  Name </b></u>
                        </label>
                    </div>
                    <div class="row">
                        <label class="pull-left">
                            <u>
                                <input type="checkbox" id="chkheader3" name="chkHeader3" class="pull-left" value="1"><b>C. Theatre List should have patient full particular for verification </b></u>
                        </label>
                    </div>


                    <div class="row" style="margin-left: 20px;">
                        <label class="pull-left ">1.FULL NAME</label>
                    </div>
                    <div class="row" style="margin-left: 30px;">
                        <div class="col-md-3">
                            <input type="radio" id="rblFullNameYh2" name="rblFullNameh2" class="pull-left" value="1">
                            <label class="pull-left " for="rbldobYh1">Yes</label>
                            <input type="radio" id="Radio2" name="rblFullNameh2" class="pull-left" value="2">
                            <label class="pull-left" for="rblFullNameNh2">No</label>

                        </div>

                    </div>

                    <div class="row" style="margin-left: 20px;">
                        <label class="pull-left ">2.Sex</label>
                    </div>
                    <div class="row" style="margin-left: 30px;">
                        <div class="col-md-3">
                            <input type="radio" id="rblSexYh2" name="rblsexh2" class="pull-left" value="1">
                            <label class="pull-left " for="rblSexYh2">Yes</label>
                            <input type="radio" id="rblSexNh2" name="rblsexh2" class="pull-left" value="2">
                            <label class="pull-left" for="rblSexYh2">No</label>

                        </div>

                    </div>





                    <div class="row" style="margin-left: 20px;">
                        <label class="pull-left ">3.Age</label>
                    </div>
                    <div class="row" style="margin-left: 30px;">
                        <div class="col-md-3">
                            <input type="radio" id="rblAgeYh2" name="rblAgeh2" class="pull-left" value="1">
                            <label class="pull-left " for="rblAgeYh2">Yes</label>
                            <input type="radio" id="rblAgeNh2" name="rblAgeh2" class="pull-left" value="2">
                            <label class="pull-left" for="rblAgeNh2">No</label>

                        </div>

                    </div>






                    <div class="row" style="margin-left: 20px;">
                        <label class="pull-left ">4.Hospital record number</label>
                    </div>
                    <div class="row" style="margin-left: 30px;">
                        <div class="col-md-3">
                            <input type="radio" id="rblMrNoYh2" name="rblMrNoh2" class="pull-left" value="1">
                            <label class="pull-left " for="rblMrNoYh2">Yes</label>
                            <input type="radio" id="rblMrNoNh2" name="rblMrNoh2" class="pull-left" value="2">
                            <label class="pull-left" for="rbldobNh1">No</label>

                        </div>

                    </div>



                    <div class="row" style="margin-left: 20px;">
                        <label class="pull-left ">5.Diagnosis </label>
                    </div>
                    <div class="row" style="margin-left: 30px;">
                        <div class="col-md-3">
                            <input type="radio" id="rblDigYh2" name="rblDigh2" class="pull-left" value="1">
                            <label class="pull-left " for="rblDigYh2">Yes</label>
                            <input type="radio" id="rblDigNh2" name="rblDigh2" class="pull-left" value="2">
                            <label class="pull-left" for="rblDigNh2">No</label>

                        </div>

                    </div>





                    <div class="row" style="margin-left: 20px;">
                        <label class="pull-left ">6.Surgical procedure to be carried out</label>
                    </div>
                    <div class="row" style="margin-left: 30px;">
                        <div class="col-md-3">
                            <input type="radio" id="rblsurYh2" name="rblsurh2" class="pull-left" value="1">
                            <label class="pull-left " for="rblsurYh2">Yes</label>
                            <input type="radio" id="rblsurNh2" name="rblsurh2" class="pull-left" value="2">
                            <label class="pull-left" for="rblsurNh2">No</label>

                        </div>

                    </div>


                    <div class="row">
                        <label class="pull-left">
                            <u>
                                <input type="checkbox" id="chkHeader4" name="chkHeader4" class="pull-left" value="1"><b>Consent form </b></u>
                        </label>
                    </div>


                    <div class="row" style="margin-left: 20px;">
                        <label class="pull-left ">1.Signed by the patient or appropriate guardian in the presence of a witness</label>
                    </div>
                    <div class="row" style="margin-left: 30px;">
                        <div class="col-md-3">
                            <input type="radio" id="rblwitnessYh4" name="rblwitnessh4" class="pull-left" value="1">
                            <label class="pull-left " for="rblwitnessYh4">Yes</label>
                            <input type="radio" id="rblwitnessNh4" name="rblwitnessh4" class="pull-left" value="2">
                            <label class="pull-left" for="rblwitnessNh4">No</label>

                        </div>

                    </div>

                    <div class="row" style="margin-left: 20px;">
                        <label class="pull-left ">2.Operation to be performed clearly and boldly stated </label>
                    </div>
                    <div class="row" style="margin-left: 30px;">
                        <div class="col-md-3">
                            <input type="radio" id="rblOprYh4" name="rblOprh4" class="pull-left" value="1">
                            <label class="pull-left " for="rblOprYh4">Yes</label>
                            <input type="radio" id="rblOprNh4" name="rblOprh4" class="pull-left" value="2">
                            <label class="pull-left" for="rblOprNh4">No</label>

                        </div>

                    </div>
                    <div class="row">
                        <label class="pull-left">
                            <u>
                                <input type="checkbox" id="chkHeaderh5" name="chkHeader5" class="pull-left" value="1"><b>Prernedication or other drugs administered  </b></u>
                        </label>
                    </div>

                    <div class="row">
                        <label class="pull-left">
                            <u>
                                <input type="checkbox" id="chkHeaderh6" name="chkHeader6" class="pull-left" value="1"><b>  Marking/shaving Aoperating site/Level eg. Rt, Lt. </b></u>
                        </label>
                    </div>
                    <div class="row">
                        <label class="pull-left">
                            <u>
                                <input type="checkbox" id="chkHeaderh7" name="chkHeader7" class="pull-left" value="1"><b>Dentures /prosthesis (Removed) </b></u>
                        </label>
                    </div>

                    <div class="row">
                        <label class="pull-left">
                            <u>
                                <input type="checkbox" id="chkHeaderh8" name="chkHeader8" class="pull-left" value="1"><b> Ensure patient has fasted overnight for GA cases </b></u>
                        </label>
                    </div>
                    <div class="row">
                        <label class="pull-left">
                            <u>
                                <input type="checkbox" id="chkHeaderh9" name="chkHeader9" class="pull-left" value="1"><b> Ensure patient is not wearing jewels eg. </b></u>
                        </label>
                    </div>




                    <div class="row" style="margin-left: 20px;">
                        <label class="pull-left ">1.Ring </label>
                    </div>
                    <div class="row" style="margin-left: 30px;">
                        <div class="col-md-3">
                            <input type="radio" id="rblRingYh9 " name="rblRingh9" class="pull-left" value="1">
                            <label class="pull-left " for="rblRingYh1">Yes</label>
                            <input type="radio" id="rblRingNh1" name="rblRingh9" class="pull-left" value="2">
                            <label class="pull-left" for="rblRingNh1">No</label>

                        </div>

                    </div>

                    <div class="row" style="margin-left: 20px;">
                        <label class="pull-left ">2.Beads</label>
                    </div>
                    <div class="row" style="margin-left: 30px;">
                        <div class="col-md-3">
                            <input type="radio" id="rblBeadsYh9" name="rblBeadsh9" class="pull-left" value="1">
                            <label class="pull-left " for="rblBeadsYh9">Yes</label>
                            <input type="radio" id="rblBeadsNh9" name="rblBeadsh9" class="pull-left" value="2">
                            <label class="pull-left" for="rblBeadsNh9">No</label>

                        </div>

                    </div>





                    <div class="row" style="margin-left: 20px;">
                        <label class="pull-left ">3.Hair pins</label>
                    </div>
                    <div class="row" style="margin-left: 30px;">
                        <div class="col-md-3">
                            <input type="radio" id="rblHpYh9" name="rblHph9" class="pull-left" value="1">
                            <label class="pull-left " for="rblHpYh9">Yes</label>
                            <input type="radio" id="rblHpNh9" name="rblHph9" class="pull-left" value="2">
                            <label class="pull-left" for="rblHpNh9">No</label>

                        </div>

                    </div>






                    <div class="row" style="margin-left: 20px;">
                        <label class="pull-left ">4.Eye glasses</label>
                    </div>
                    <div class="row" style="margin-left: 30px;">
                        <div class="col-md-3">
                            <input type="radio" id="rblegYh9" name="rblegh9" class="pull-left" value="1">
                            <label class="pull-left " for="rblegYh9">Yes</label>
                            <input type="radio" id="rblegNh9" name="rblegh9" class="pull-left" value="2">
                            <label class="pull-left" for="rblegNh9">No</label>

                        </div>

                    </div>



                    <div class="row" style="margin-left: 20px;">
                        <label class="pull-left ">5.Religious medals </label>
                    </div>
                    <div class="row" style="margin-left: 30px;">
                        <div class="col-md-3">
                            <input type="radio" id="rblRMYh9" name="rblRMh9" class="pull-left" value="1">
                            <label class="pull-left " for="rblRMYh9">Yes</label>
                            <input type="radio" id="rblRMNh9" name="rblRMh9" class="pull-left" value="2">
                            <label class="pull-left" for="rblRMNh9">No</label>

                        </div>

                    </div>





                    <div class="row" style="margin-left: 20px;">
                        <label class="pull-left ">6.Hearing aid(s)</label>
                    </div>
                    <div class="row" style="margin-left: 30px;">
                        <div class="col-md-3">
                            <input type="radio" id="rblHAYh9" name="rblHAh9" class="pull-left" value="1">
                            <label class="pull-left " for="rblHAYh9">Yes</label>
                            <input type="radio" id="rblHANh9" name="rblHAh9" class="pull-left" value="2">
                            <label class="pull-left" for="rblHANh9">No</label>

                        </div>

                    </div>



                    <div class="row" style="margin-left: 20px;">
                        <label class="pull-left ">7.Money</label>
                    </div>
                    <div class="row" style="margin-left: 30px;">
                        <div class="col-md-3">
                            <input type="radio" id="rblMonYh9" name="rblMonh9" class="pull-left" value="1">
                            <label class="pull-left " for="rblMonYh9">Yes</label>
                            <input type="radio" id="rblMonNh9" name="rblMonh9" class="pull-left" value="2">
                            <label class="pull-left" for="rblMonNh9">No</label>

                        </div>

                    </div>







                    <div class="row" style="margin-left: 20px;">
                        <label class="pull-left ">8.Wrist watches</label>
                    </div>
                    <div class="row" style="margin-left: 30px;">
                        <div class="col-md-3">
                            <input type="radio" id="rblwwYh9" name="rblwwh9" class="pull-left" value="1">
                            <label class="pull-left " for="rblwwYh9">Yes</label>
                            <input type="radio" id="rblwwNh9" name="rblwwh9" class="pull-left" value="2">
                            <label class="pull-left" for="rblwwNh9">No</label>

                        </div>

                    </div>






                    <div class="row" style="margin-left: 20px;">
                        <label class="pull-left ">9.Wig </label>
                    </div>
                    <div class="row" style="margin-left: 30px;">
                        <div class="col-md-3">
                            <input type="radio" id="rblWigYh9" name="rblWigh9" class="pull-left" value="1">
                            <label class="pull-left " for="rblWigYh9">Yes</label>
                            <input type="radio" id="Radio7" name="rblWigh9" class="pull-left" value="2">
                            <label class="pull-left" for="rblWigNh9">No</label>

                        </div>

                    </div>



                    <div class="row" style="margin-left: 20px;">
                        <label class="pull-left ">
                            10. Undergarment
                        </label>
                    </div>
                    <div class="row" style="margin-left: 30px;">
                        <div class="col-md-3">
                            <input type="radio" id="rblUgYh9" name="rblUgh9" class="pull-left" value="1">
                            <label class="pull-left " for="rblUgYh9">Yes</label>
                            <input type="radio" id="rblUgNh9" name="rblUgh9" class="pull-left" value="2">
                            <label class="pull-left" for="rblUgNh9">No</label>

                        </div>

                    </div>



                    <div class="row" style="margin-left: 20px;">
                        <label class="pull-left ">11.Artificial extremities</label>
                    </div>
                    <div class="row" style="margin-left: 30px;">
                        <div class="col-md-3">
                            <input type="radio" id="rblAeYh9" name="rblAeh9" class="pull-left" value="1">
                            <label class="pull-left " for="rblAeYh9">Yes</label>
                            <input type="radio" id="rblAeNh9" name="rblAeh9" class="pull-left" value="2">
                            <label class="pull-left" for="rblAeNh9">No</label>

                        </div>

                    </div>




                </div>




            </div>
            <div class="row">
                <center>
                    <input type="button" id="btnsavesurgery" onclick="SavessclMaster()" value="Save" runat="server"/>
                     <input type='button' id='btnprintdiv' value='Print' onclick="printDiv()" runat="server" style="display:none" />

                </center>
            </div>
        </div>
    </form>
</body>
</html>

