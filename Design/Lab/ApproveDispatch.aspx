<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="ApproveDispatch.aspx.cs" Inherits="Design_Lab_ApproveDispatch" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="CKEditor.NET" Namespace="CKEditor.NET" TagPrefix="CKEditor" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <link rel="Stylesheet" href="../../Scripts/chosen.css" type="text/css" />
    <link rel="Stylesheet" href="Style/jquery-ui.css" type="text/css" />
    <link rel="Stylesheet" href="Script/JCrop/jcrop_jquery.css" type="text/css" />
    <link rel="Stylesheet" href="Script/uploadify/uploadify.css" type="text/css" />
    <link rel="Stylesheet" href="../../Scripts/fancybox/jquery.fancybox-1.3.4.css" type="text/css" />
    <link rel="Stylesheet" href="Style/ResultEntryCSS.css" type="text/css" />
    <link href="../../Scripts/Handsome-Table/handsontable.full.min.css" rel="stylesheet" />
    <%--<webopt:bundlereference ID="BundleReference6" runat="server" Path="~/Content/css" />--%>
    <%--<webopt:bundlereference ID="BundleReference7" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />--%>

    <script type="text/javascript" src="../../Scripts/Handsome-Table/handsontable.full.js"></script>
    <script type="text/javascript" src="Script/ResultEntryJS.js"></script>
    <script type="text/javascript" src="../../Scripts/chosen.jquery.js"></script>
    <script type="text/javascript" src="../../Scripts/jquery-ui-1.10/jquery-ui.js"></script>
    <script src="../../Scripts/Common.js"></script>
    <%--<%: Scripts.Render("~/bundles/JQueryUIJs") %>--%>
    <%--<%: Scripts.Render("~/bundles/handsontable") %>--%>
    <%--<%: Scripts.Render("~/bundles/MsAjaxJs") %>--%>
    <%--<%: Scripts.Render("~/bundles/Chosen") %>--%>
    <%--<%: Scripts.Render("~/bundles/ResultEntry") %>--%>
    <%--<script type="text/javascript" src="../../Scripts/jquery-migrate-3.0.0.min.js"></script>--%>
    <style type="text/css">
        .circleclass {
            height: 25px;
            width: 34px;
            border-radius: 50%;
        }

        .uploadify {
            position: relative;
            margin-bottom: 1em;
            margin-left: 40%;
            margin-top: -40px;
            z-index: 999;
        }

        #MainInfoDiv {
            height: 480px !important;
        }

        #divimgpopup {
            height: 600px !important;
        }

        .ReRun {
            background-color: #F781D8;
        }

        tr.FullRowColorInRerun td {
            background-color: #F781D8 !important;
        }

        tr.FullRowColorInCancelByInterface td {
            background-color: #abb54c;
        }

        #popup_box1 {
            display: none; /* Hide the DIV */
            position: fixed;
            _position: absolute; /* hack for internet explorer 6 */
            height: 300px;
            width: 300px;
            background: #FFFFFF;
            left: 400px;
            top: 150px;
            z-index: 100; /* Layering ( on-top of others), if you have lots of layers: I just maximized, you can change it yourself */
            margin-left: 15px;
            /* additional features, can be omitted */
            border: 2px solid #ff0000;
            padding: 15px;
            font-size: 15px;
            -moz-box-shadow: 0 0 5px #ff0000;
            -webkit-box-shadow: 0 0 5px #ff0000;
            box-shadow: 0 0 5px #ff0000;
        }

        #popup_box3 {
            display: none; /* Hide the DIV */
            position: fixed;
            _position: absolute; /* hack for internet explorer 6 */
            height: 300px;
            width: 300px;
            background: #FFFFFF;
            left: 150px;
            top: 150px;
            z-index: 100; /* Layering ( on-top of others), if you have lots of layers: I just maximized, you can change it yourself */
            margin-left: 15px;
            /* additional features, can be omitted */
            border: 2px solid #ff0000;
            padding: 15px;
            font-size: 15px;
            -moz-box-shadow: 0 0 5px #ff0000;
            -webkit-box-shadow: 0 0 5px #ff0000;
            box-shadow: 0 0 5px #ff0000;
        }

        #divunapproved {
            display: none; /* Hide the DIV */
            position: fixed;
            _position: absolute; /* hack for internet explorer 6 */
            height: 300px;
            width: 600px;
            background: #FFFFFF;
            left: 400px;
            top: 150px;
            z-index: 100; /* Layering ( on-top of others), if you have lots of layers: I just maximized, you can change it yourself */
            margin-left: 15px;
            /* additional features, can be omitted */
            border: 2px solid #ff0000;
            padding: 15px;
            font-size: 15px;
            -moz-box-shadow: 0 0 5px #ff0000;
            -webkit-box-shadow: 0 0 5px #ff0000;
            box-shadow: 0 0 5px #ff0000;
        }



        .handsontableInputHolder {
            z-index: 1000;
        }

        .handsontable.autocompleteEditor {
            border: 1px solid #AAAAAA;
            box-shadow: 10px 10px 15px #AAAAAA;
            background-color: white;
            min-width: 600px;
        }

            .handsontable.autocompleteEditor.handsontable {
                padding-right: 0px;
            }


        .autocompleteEditor .wtHolder {
            min-width: 600px;
        }


        .autocompleteEditor .htCore {
            border: none !important;
            -webkit-box-shadow: none !important;
            box-shadow: none !important;
            min-width: 600px !important;
        }

        .autocompleteEditor .ht_clone_top, .autocompleteEditor .ht_clone_left {
            display: none;
        }

        .auto-style1 {
            width: 20px;
        }

        .auto-style2 {
            height: 41px;
        }
    </style>

    <div class="alert fade" style="position: absolute; left: 35%; border-radius: 15px; z-index: 11111; top: 60%;">
        <p id="msgField" style="color: white; padding: 10px; font-weight: bold;"></p>
    </div>

    <Ajax:ScriptManager ID="ScriptManager1" runat="server" AsyncPostBackErrorMessage="Error...">
    </Ajax:ScriptManager>


    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Pathologist Report Approval</b>
        </div>
        <div class="POuter_Box_Inventory"> 
                <div class="Purchaseheader">
                    Search Option
             &nbsp;&nbsp;<asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:Label ID="lblTotalPatient" ForeColor="Red" runat="server" CssClass="ItDoseLblError" />
                </div>
           
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">
                    <asp:DropDownList ID="ddlSearchType" CssClass="chosen-select" runat="server" Width="120px">
                        <asp:ListItem Value="pli.BarcodeNo">Barcode No.</asp:ListItem>
                        <asp:ListItem Value="lt.Patient_ID">Patient ID</asp:ListItem>
                        <asp:ListItem Value="pli.LedgerTransactionNo" Selected="True">Lab No</asp:ListItem>
                        <asp:ListItem Value="lt.PName">Patient Name</asp:ListItem>
                    </asp:DropDownList>
                        </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtSearchValue" runat="server" Width="205px"></asp:TextBox>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">
                        Department
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlDepartment" CssClass="chosen-select" Width="205px" runat="server">
                    </asp:DropDownList>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">
                        <asp:CheckBox ID="chkPanel0" runat="server" onchange="BindTest();" Text="Test" ClientIDMode="Static" Style="font-weight: 700;" />
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlinvestigation" class="ddlinvestigation  chosen-select" Width="205px" runat="server">
                    </asp:DropDownList>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Patient Type</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlLocation_Type" Width="205px" runat="server">
                        <asp:ListItem Value="ALL" Selected="True">ALL</asp:ListItem>
                        <asp:ListItem Value="OPD">OPD</asp:ListItem>
                        <asp:ListItem Value="IPD">IPD</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">
                        From Date
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtFormDate" runat="server" Width="120"></asp:TextBox>
                    <cc1:CalendarExtender ID="ce_dtfrom" runat="server" Format="dd-MMM-yyyy" PopupButtonID="txtFormDate" TargetControlID="txtFormDate" />
                    <asp:TextBox ID="txtFromTime" runat="server" Width="80"></asp:TextBox>
                    <cc1:MaskedEditExtender runat="server" ID="mee_txtFromTime" Mask="99:99:99" TargetControlID="txtFromTime"
                        AcceptAMPM="false" AcceptNegative="None" MaskType="Time">
                    </cc1:MaskedEditExtender>
                    <cc1:MaskedEditValidator runat="server" ID="mev_txtFromTime"
                        ControlExtender="mee_txtFromTime"
                        ControlToValidate="txtFromTime"
                        InvalidValueMessage="*"></cc1:MaskedEditValidator>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">
                        To Date
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtToDate" CssClass="ItDoseTextinputText" runat="server" ReadOnly="true" Width="120px"></asp:TextBox>
                    <cc1:CalendarExtender ID="ce_dtTo" runat="server" Format="dd-MMM-yyyy" PopupButtonID="txtToDate" TargetControlID="txtToDate" />


                    <asp:TextBox ID="txtToTime" runat="server" Width="80px"></asp:TextBox>
                    <cc1:MaskedEditExtender runat="server" ID="mee_txtToTime" Mask="99:99:99" TargetControlID="txtToTime"
                        AcceptAMPM="false" AcceptNegative="None" MaskType="Time">
                    </cc1:MaskedEditExtender>
                    <cc1:MaskedEditValidator runat="server" ID="mev_txtToTime"
                        ControlExtender="mee_txtToTime" ControlToValidate="txtToTime"
                        InvalidValueMessage="*"></cc1:MaskedEditValidator>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Centre</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlCentreAccess" class="ddlcentreAccess  chosen-select chosen-container" Width="205px" runat="server">
                        <asp:ListItem Value=""></asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="col-md-3">
                </div>
                <div class="col-md-5">
                </div>
                 <div class="col-md-3">
                    <label class="pull-left">Result Type</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlresultstatus"  runat="server" Width="205px">
                        <asp:ListItem Value="A" Selected="True">ALL</asp:ListItem>
                        <asp:ListItem Value="CH">Critical High</asp:ListItem>
                        <asp:ListItem Value="CL">Critical Low</asp:ListItem>
                        <asp:ListItem Value="H">High</asp:ListItem>
                        <asp:ListItem Value="L">Low</asp:ListItem>
                        <asp:ListItem Value="N">Normal</asp:ListItem>
                    </asp:DropDownList>
                </div>
            </div>
            <div class="row" style="text-align: center">
                <input id="btnSearch" type="button" value="Search" class="searchbutton" onclick="SearchSampleCollection('A');" />
                 <asp:Button ID="btnReport" runat="server" Text="Report" class="ItDoseButton" onclick="btnReport_Click"/>
            </div>

            <div  >
                  <div class="row"  style="margin-left: 370px;">  
                        <div class="col-md-4">
                            <button type="button" onclick="SearchSampleCollection('CH');"  style="width:25px;height:25px;margin-left:5px;float:left;background-color:#ff0000;" class="circle"></button>
                            <b style="margin-top:5px;margin-left:5px;float:left">Critical High</b>
                        </div>
                        <div class="col-md-4">
                            <button type="button"  style="width:25px;height:25px;margin-left:5px;float:left;background-color:#deb887;" class="circle" onclick="SearchSampleCollection('CL');"></button>
                            <b style="margin-top:5px;margin-left:5px;float:left">Critical Low</b>
                        </div>
                        <div class="col-md-3">
                             <button type="button"  style="width:25px;height:25px;margin-left:5px;float:left;background-color:pink;" class="circle" onclick="SearchSampleCollection('H');"></button>
                            <b style="margin-top:5px;margin-left:5px;float:left">High</b>
                        </div>
                         <div class="col-md-3">
                             <button type="button"  style="width:25px;height:25px;margin-left:5px;float:left;background-color:yellow;" class="circle" onclick="SearchSampleCollection('L');"></button>
                            <b style="margin-top:5px;margin-left:5px;float:left">Low</b>
                        </div>
                         <div class="col-md-3">
                             <button type="button"  style="width:25px;height:25px;margin-left:5px;float:left;background-color:white;" class="circle" onclick="SearchSampleCollection('N');"></button>
                            <b style="margin-top:5px;margin-left:5px;float:left">Normal</b>
                        </div>
                     </div>
            </div>

        </div>

        <div class="POuter_Box_Inventory">
            <div id="PagerDiv1" style="display: none; background-color: white; width: 99%; padding-left: 7px;">
            </div>

            <div id="divPatient" class="vertical" style="overflow: auto; height: 350px;"></div>
            <div id="MainInfoDiv" class="vertical" align="center">
                <div class="Purchaseheader">
                    <div class="DivInvName" style="color: Black; cursor: pointer; font-weight: bold;"></div>
                </div>
                <div id="divInvestigation">
                </div>

                <div id="SelectedPatientinfo">
                </div>
                <div style="display: none;">
                    <br />

                </div>
                <div style="padding-top: 2px;" class="btnDiv">
                    <p id="commentbox1"><span id="spInvestigationName" style="font-size: 14px; font-weight: bold; color: red"></span><span id="commentHead1"></span></p>
                    <a id="various2" style="display: none">Ajax</a>
                </div>
                <div>
                </div>

            </div>

            <%-- <asp:DropDownList ID="ddlApprove"  CssClass="ApprovalId_1 ApprovalId_3 ApprovalId_4"  runat="server" ></asp:DropDownList>  --%>
            <div id="divapprove" style="display: none;">
                <center>

                    <asp:DropDownList ID="ddlApprove" runat="server" AppendDataBoundItems="True" Style="width: 200px;"></asp:DropDownList>

                    <input type="button" id="btnapproved" class="ItDoseButton" onclick="ApproveDispatchAll();" value="Approve & Dispatch" />
                    &nbsp;&nbsp;
                    <a href="MachineResultEntry.aspx" target="_blank">Result Entry</a>
                </center>

            </div>
        </div>
    </div>
    <div id="deltadiv" style="display: none; position: absolute;">
    </div>
    <div id="sampledate" style="display: none; position: absolute;"></div>
    <script type="text/javascript">

        var _PageSize = 100;
        var _PageNo = 0;
        $(document).ready(function () {
            var config = {
                '.chosen-select': {},
                '.chosen-select-deselect': { allow_single_deselect: true },
                '.chosen-select-no-single': { disable_search_threshold: 10 },
                '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' },
                '.chosen-select-width': { width: "95%" }
            }
            for (var selector in config) {
                $(selector).chosen(config[selector]);
            }
            $('#<%=txtSearchValue.ClientID%>').keypress(function (ev) {
                if (ev.which === 13)
                    SearchSampleCollection('A');
            });
        });
    </script>


    <script type="text/javascript">
        var PatientData = '';
        var LabObservationData = '';
        var _test_id = '';
        var _barcodeno = '';
        var hot2;
        var modal = "";
        var span = "";
        var currentRow = 1;
        var resultStatus = "";
        var criticalsave = "0";
        var macvalue = "0";
        var LedgerTransactionNo = "";
        var MYSampleStatus = "";
        var elt;
        // for image crop
        var Year = '<%=Year %>';
        var Month = '<%=Month %>';
        var image;
        var ImgTag;
        var savedvalue = "";
        var formattedDate;
        //end
        var mouseX;
        var mouseY;


        $(document).mousemove(function (e) {
            mouseX = e.pageX;
            mouseY = e.pageY;
        });


        function getme(CollectionDate, ReceiveDate, ResultEnterydate, ProvisionalDispatchDate) {
            $('#trrow').remove();
            var url = "<div id='show' >";
            $('#trrow').remove();
            url += "<table id='trrow' cellspacing='0' style='width:550px;font-family:Arial; font-size:12px; '  rules='all' frame='box' border='1' >";
            url += " <tr style='background-color:black;color:white; font-weight:bold;'>                        ";
            url += "        <th style='width:200px;text-align:left;'>Sample Collection Date</th>             ";
            url += "        <th style='width:110px;text-align:left;'>Dept. Receive Date </th>                        ";
            url += "        <th style='width:110px;text-align:left;'>Result Entry Date</th>                           ";
            url += "        <th style='width:110px;text-align:left;display:none;'>Provisional Dispatch Date</th>                           ";
            url += "    </tr>     ";
            url += " <tr  style='background-color:#d3d3d3;color:black; font-weight:bold;'>                        ";
            url += "        <td style='width:200px;text-align:left;'>" + CollectionDate + "</td>             ";
            url += "        <td style='width:200px;text-align:left;'>" + ReceiveDate + "</td>                        ";
            url += "        <td style='width:200px;text-align:left;'>" + ResultEnterydate + "</td>                           ";
            url += "        <td style='width:200px;text-align:left;display:none;'>" + ProvisionalDispatchDate + "</td>                           ";
            url += "    </tr>                                                                          ";
            url += "	</table>                                                                          ";
            url += "	</div>                                                                          ";
            $('#sampledate').append(url);
            $('#sampledate').css({ 'top': mouseY, 'left': mouseX }).show();
        }


        function hideme() {

            $('#sampledate').hide();
        }

        $(document).ready(function () {
            // ManageDivHeight();
            $('#MainInfoDiv').hide();
                <%if (Util.GetString(Request.QueryString["cmd"]) == "changebarcode")
                  {%>
            $('#divPatient').removeClass('vertical');
            $('#divPatient').addClass('horizontal');
            // $('#divPatient').css('height', '450px');
            $('#MainInfoDiv').hide();
            $('.btnDiv').hide();
            $('#btnSide').hide();
            $('#btnUpdateBarcodeInfo').show();
                <%}%>

            UpdateSampleStatus();

            modal = document.getElementById('myModal');
            // Get the button that opens the modal

            // Get the <span> element that closes the modal
            span = document.getElementsByClassName("close")[0];
            // When the user clicks on the button, open the modal 
            //btn.onclick = function () {
            //    modal.style.display = "block";
            //}
            // When the user clicks on <span> (x), close the modal
            span.onclick = function () {
                modal.style.display = "none";
            }
            // When the user clicks anywhere outside of the modal, close it
            window.onclick = function (event) {
                if (event.target == modal) {
                    modal.style.display = "none";
                }
            }
        });
        function ManageDivHeight() {
            $('#divInvestigation').removeClass('vertical');
            $('#divPatient').removeClass('vertical');
            $('#divInvestigation').addClass('horizontal');
            $('#divPatient').addClass('horizontal');
        }
        function UpdateSampleStatus() {
            try {
                MYSampleStatus = elt.options[elt.selectedIndex].text;
            }
            catch (e) {
                MYSampleStatus = "Tested";
            }
            $('.SampleStatus').hide();
            if (MYSampleStatus == "Forwarded") {
                $('#btnApprovedLabObs').show();
                $('#btnUnForwardLabObs').show();

            }

        }

        var
            data,
            container1,
            hot1;

        function SearchSampleCollection(flag) {
            //   alert(flag);
            var _Flag = flag;
            var department = $('#<%=ddlDepartment.ClientID%>').val();
          //  if (department == 0 && $("#<%=txtSearchValue.ClientID %>").val() == "") {
          //      var msg = 'Please select department';
          //      modelAlert(msg);
          //      return false;
          //  }

            var investigationID = "";
            var PanelId = "";
            _PageNo = 0;
            var HomeCollectionFlag = 0;
            var TRFNo = 0;
            var prescriptionNo = 0;
            var chkcontrol = 0;
            var chkdummy = 0;

            var Inv_ID = $('#<%=ddlinvestigation.ClientID%>').val();
            $('#divPatient').show();
            $('#MainInfoDiv').hide();



            $('#btnSave').hide();
            $('#divPatient').html('');
            $('#divInvestigation').html('');
            $('.demo').attr('disabled', true);

            var chremarks = 0;
            if ($("#ctl00_ContentPlaceHolder1_chremarks").prop("checked") == true)
                chremarks = 1;

            var chcomments = 0;
            if ($("#ctl00_ContentPlaceHolder1_chcomments").prop("checked") == true)
                chcomments = 1;
            $("#btnSearch").attr('disabled', 'disabled').val('Search');
            //   $.blockUI();
            $.ajax({
                url: "ApproveDispatch.aspx/PatientSearch",
                data: '{SearchType: "' + $("#<%=ddlSearchType.ClientID %>").val() + '",SearchValue:"' + $("#<%=txtSearchValue.ClientID %>").val() + '",FromDate:"' + $("#<%=txtFormDate.ClientID %>").val() + '",ToDate: "' + $("#<%=txtToDate.ClientID%>").val() + '", CentreID:"' + $("#<%=ddlCentreAccess.ClientID%>").val() + '",Department:"' + $("#<%=ddlDepartment.ClientID%>").val() + '",TimeFrm:"' + $("#<%=txtFromTime.ClientID%>").val() + '",Timeto:"' + $("#<%=txtToTime.ClientID%>").val() + '",InvestigationId:"' + investigationID + '", _Flag: "' + _Flag + '",Inv_ID : "' + Inv_ID + '"}', // parameter map 
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                renderAllRows: true,
                success: function (result) {
                    if (result.d == 'SessionOut') {
                        window.location.reload();
                    }
                    PatientData = $.parseJSON(result.d); if (PatientData == "-1") {
                        $('#<%=lblTotalPatient.ClientID%>').text('');
                        $('#btnUpdateBarcodeInfo').attr('disabled', true);
                        $("#btnSearch").removeAttr('disabled').val('Search');
                        //   $.unblockUI();
                        modelAlert('Your Session Expired.... Please Login Again');
                        return;
                    }
                    if (PatientData.length == 0) {
                        $('#<%=lblTotalPatient.ClientID%>').text('');
                        $('#btnUpdateBarcodeInfo').attr('disabled', true);
                        $("#btnSearch").removeAttr('disabled').val('Search');
                        //   $.unblockUI();
                        //  $("#<%=lblMsg.ClientID %>").text('No Record Found');
                        modelAlert("No Record Found");
                        return;
                    }
                    else {
                        $("#divapprove").css("display", "block");
                        //UpdateSampleStatus();
                        currentRow = 1;
                        $("#<%=lblMsg.ClientID %>").text('');
                        $('#<%=lblTotalPatient.ClientID%>').text('Total Patient: ' + PatientData[0].TotalRecord);
                        $('#btnUpdateBarcodeInfo').attr('disabled', false);
                        _PageNo = PatientData[0].TotalRecord / _PageSize;
                        data = PatientData;
                        container1 = document.getElementById('divPatient');
                        hot1 = new Handsontable(container1, {
                            data: PatientData,
                            colHeaders: [
                                "S.No.", "<th><input type='checkbox' name='chkall' id='chkall' onclick='chkUncheck(this);' /></th>", "Patient Info.", "Lab No.", "Barcode No.", "Patient Type", "Test Name", "Lab Observation", "Value", "MinValue", "MaxValue", "Unit"
                            ],
                            readOnly: true,
                            currentRowClassName: 'currentRow',
                            columns: [
                                { renderer: AutoNumberRenderer, width: '60px' },
                                { renderer: checkboxcreate },
                                { renderer: pname, width: '150px' },
                                { renderer: labno, width: '150px' },
                                { renderer: barcodeno, width: '140px' },
                                { renderer: Location, width: '100px' },
                                { renderer: tooltipfun, width: '140px' },
                                { renderer: Observationname },
                                { renderer: colorfun, width: '130px' },
                                { data: 'MinValue' },
                                { data: 'MaxValue' },
                                { data: 'readingFormat' },

                                //{ data: 'colledate'  },
                                //{ data: 'DATE' },
                                //{ data: 'ResultEnteredDate' },
                                //{ renderer: checkboxcreate },

                            ],

                            stretchH: "all",
                            autoWrapRow: false,
                            manualColumnFreeze: true,
                            fillHandle: false,
                            renderAllRows: true,
                            // rowHeaders: true,

                            cells: function (row, col, prop) {
                                var cellProperties = {};
                                cellProperties.className = PatientData[row].Status;
                                return cellProperties;
                            },
                            beforeChange: function (change, source) {
                                updateRemarks(change);
                            }
                        });

                        hot1.render();
                        //hot1.selectCell(0, 0);
                        $("#btnSearch").removeAttr('disabled').val('Search');
                        //   $.unblockUI();

                        //return;
                    }

                    var myval = "";
                    if (_PageNo > 1 && _PageNo < 50) {

                        for (var j = 0; j < _PageNo; j++) {
                            var me = parseInt(j) + 1;
                            myval += '<a id="anch' + me + '" style="padding:2px;font-weight:bold;color:blue;" href="javascript:void(0);" onclick="show(\'' + j + '\');"  >' + me + '</a>';

                        }
                    }
                    else if (_PageNo > 50) {

                        for (var j = 0; j < 50; j++) {
                            var me = parseInt(j) + 1;
                            myval += '<a style="padding:2px;font-weight:bold;" href="javascript:void(0);" onclick="show(\'' + j + '\');"  >' + me + '</a>';

                        }
                        myval += '&nbsp;&nbsp;<select onchange="shownextrecord()" id="myddl">';
                        myval += '<option value="Select">Select Page</option>';
                        for (var j = 50; j < _PageNo; j++) {
                            var me = parseInt(j) + 1;
                            myval += '<option value="' + j + '">' + me + '</option>';

                        }
                        myval += "</select>";
                    }




                    //$('#PagerDiv1').html(myval);
                    //$('#PagerDiv1').show();
                },
                error: function (xhr, status) {
                    $("#btnSearch").removeAttr('disabled').val('Search');
                    //   $.unblockUI();
                    $('#divPatient').html('');
                    modelAlert('Please Contact to ItDose Support Team');
                    window.status = status + "\r\n" + xhr.responseText;
                }

            });
            // ManageDivHeight();
        }

        // test bind
        function BindTest() {
            var ddlDoctor = $("#<%=ddlinvestigation.ClientID %>");
            var checkBox = document.getElementById("chkPanel0");

            if (checkBox.checked == true) {
                $("#<%=ddlinvestigation.ClientID %> option").remove();
                //   $.blockUI();
                $.ajax({
                    url: "ApproveDispatch.aspx/GetTestMaster",
                    data: '{}', // parameter map
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        PanelData = $.parseJSON(result.d);
                        if (PanelData.length == 0) {
                        }
                        else {
                            ddlDoctor.append($("<option></option>").val(0).html("SELECT"));
                            for (i = 0; i < PanelData.length; i++) {
                                ddlDoctor.append($("<option></option>").val(PanelData[i]["testid"]).html(PanelData[i]["testname"]));
                            }
                        }
                        ddlDoctor.trigger('chosen:updated');
                        //   $.unblockUI();
                    },
                    error: function (xhr, status) {
                        ddlDoctor.trigger('chosen:updated');
                        //   $.unblockUI();
                        window.status = status + "\r\n" + xhr.responseText;
                    }
                });
            }
            else {
                ddlDoctor.val(0);
                ddlDoctor.trigger('chosen:updated');
            }
        }

        function SearchSampleCollectionpagging(pageno) {
            var investigationID = "";
            var PanelId = "";
            var HomeCollectionFlag = 0;
            var TRFNo = 0;
            var prescriptionNo = 0;
            var chkcontrol = 0;
            var chkdummy = 0;


            if ($("#chkHomeCollection").prop("checked") == true)
                HomeCollectionFlag = 1;

            if ($("#chktrfenter").prop("checked") == true)
                TRFNo = 1;

            if ($("#chkpre").prop("checked") == true)
                prescriptionNo = 1;


            if ($("#chkcontrol").prop("checked") == true)
                chkcontrol = 1;

            //if ($("#chkdummy").attr("checked"))
            if ($("#chkdummy").prop('checked') == true)
                chkdummy = 1;






            $('#divPatient').show();
            $('#MainInfoDiv').hide();


            $('#btnSave').hide();
            $('#divPatient').html('');
            $('#divInvestigation').html('');
            $('.demo').attr('disabled', true);
            var _Flag = 'A';
            var chremarks = 0;
            if ($("#ctl00_ContentPlaceHolder1_chremarks").prop("checked") == true)
                chremarks = 1;

            var chcomments = 0;
            if ($("#ctl00_ContentPlaceHolder1_chcomments").prop("checked") == true)
                chcomments = 1;
            $("#btnSearch").attr('disabled', 'disabled').val('Search');
            //   $.blockUI();
            $.ajax({
                url: "ApproveDispatch.aspx/PatientSearch",
                data: '{ SearchType: "' + $("#<%=ddlSearchType.ClientID %>").val() + '",SearchValue:"' + $("#<%=txtSearchValue.ClientID %>").val() + '",FromDate:"' + $("#<%=txtFormDate.ClientID %>").val() + '",CentreID:"' + $("#<%=ddlCentreAccess.ClientID%>").val() + '",Department:"' + $("#<%=ddlDepartment.ClientID%>").val() + '",TimeFrm:"' + $("#<%=txtFromTime.ClientID%>").val() + '",InvestigationId:"' + investigationID + '",chremarks:"' + chremarks + '",chcomments:"' + chcomments + '",HomeCollectionFlag:"' + HomeCollectionFlag + '",TRFNo:"' + TRFNo + '",prescriptionNo:"' + prescriptionNo + '",chkcontrol:"' + chkcontrol + '",chkdummy:"' + chkdummy + '" ,PageNo: "' + pageno + '", PageSize: "' + _PageSize + '",_Flag: "' + _Flag + '"}', // parameter map 
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                renderAllRows: true,
                success: function (result) {
                    if (result.d == 'SessionOut') {
                        window.location.reload();
                    }
                    $('.SampleStatus').hide();
                    $('.SampleStatus').attr('disabled', true);

                    PatientData = $.parseJSON(result.d);
                    if (PatientData == "-1") {
                        $('#<%=lblTotalPatient.ClientID%>').text('');
                        $('#btnUpdateBarcodeInfo').attr('disabled', true);
                        $("#btnSearch").removeAttr('disabled').val('Search');
                        //   $.unblockUI();
                        ModelAlert('Your Session Expired.... Please Login Again');
                        return;
                    }
                    if (PatientData.length == 0) {
                        $('#<%=lblTotalPatient.ClientID%>').text('');
                        $('#btnUpdateBarcodeInfo').attr('disabled', true);
                        $("#btnSearch").removeAttr('disabled').val('Search');
                        //   $.unblockUI();
                        $("#<%=lblMsg.ClientID %>").text('No Record Found');
                        modelAlert('No Record Found');
                        $('#PagerDiv1').html('');
                        //$('#PagerDiv1').show();
                        return;
                    }
                    else {
                        UpdateSampleStatus();
                        currentRow = 1;
                        $("#<%=lblMsg.ClientID %>").text('');
                        $('#<%=lblTotalPatient.ClientID%>').text('Total Patient: ' + PatientData.length);
                        $('#btnUpdateBarcodeInfo').attr('disabled', false);
                        // var output = $('#tb_PatientLabSearch').parseTemplate(PatientData);
                        // $('#divPatient').html(output);

                        data = PatientData;
                        container1 = document.getElementById('divPatient');
                        hot1 = new Handsontable(container1, {
                            data: PatientData,
                            colHeaders: [
                                "S.No.", "<th><input type='checkbox' name='chkall' id='chkall' onclick='chkUncheck(this);' /></th>", "Patient Info", "Lab No.", "Barcode No.", "Test Name", "Lab Observation", "Value", "MinValue", "MaxValue", "Unit"
                            ],
                            readOnly: true,
                            currentRowClassName: 'currentRow',
                            //copyPaste: false,
                            columns: [

                                { renderer: AutoNumberRenderer, width: '60px' },
                                { renderer: checkboxcreate },
                                { renderer: pname, width: '150px' },
                                { renderer: labno, width: '100px' },
                                { renderer: barcodeno, width: '100px' },
                                { renderer: tooltipfun, width: '140px' },
                                { renderer: Observationname, },
                                { renderer: colorfun, width: '140px' },
                                { data: 'MinValue' },
                                { data: 'MaxValue' },
                                { data: 'readingFormat' },
                                //{ data: 'colledate' },
                                //{ data: 'DATE' },
                                //{ data: 'ResultEnteredDate' },

                            ],
                            stretchH: "all",
                            autoWrapRow: false,
                            manualColumnFreeze: true,
                            fillHandle: false,
                            renderAllRows: true,
                            // rowHeaders: true,
                            cells: function (row, col, prop) {
                                var cellProperties = {};
                                cellProperties.className = PatientData[row].Status;
                                return cellProperties;
                            },
                            beforeChange: function (change, source) {
                                updateRemarks(change);
                            }
                        });
                        hot1.render();
                        hot1.selectCell(0, 0);
                        //if (PatientData.length > 0)
                        //    SearchInvestigation(PatientData[0].ledgerTransactionNO);
                        $("#btnSearch").removeAttr('disabled').val('Search');
                        //   $.unblockUI();

                    }


                },
                error: function (xhr, status) {
                    $("#btnSearch").removeAttr('disabled').val('Search');
                    //   $.unblockUI();
                    $('#divPatient').html('');
                    modelAlert('Please Contact to ItDose Support Team');
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }


        function chkUncheck(ctrl) {
            var morecheckbox = $(ctrl).attr("class");
            if ($(ctrl).is(":checked")) {
                $(".mmchk").attr('checked', true);
            }
            else {

                $(".mmchk").attr('checked', false);
            }
        }

        function show(pageno) {
            //var id = parseInt(pageno)+1;
            //$('#anch' + id + '').css("color", "Red");
            SearchSampleCollectionpagging(pageno);
        }

        function shownextrecord() {
            var mm = $('#myddl option:selected').val();
            if (mm != "Select") {
                show(mm);
            }
        }




        function callPatientDetail(PTest_ID, PLeddNo) {
            var href = "../Lab/PatientSampleinfoPopup.aspx?TestID=" + PTest_ID + "&LabNo=" + PLeddNo;
            $.fancybox({
                maxWidth: 860,
                maxHeight: 800,
                fitToView: false,
                width: '80%',
                height: '70%',
                href: href,
                autoSize: false,
                closeClick: false,
                openEffect: 'none',
                closeEffect: 'none',
                'type': 'iframe'
            }
            );
        }
        function callShowAttachment(PLeddNo) {
            var href = "../Lab/AddFileRegistration.aspx?labno=" + PLeddNo;
            $.fancybox({
                maxWidth: 860,
                maxHeight: 800,
                fitToView: false,
                width: '80%',
                height: '70%',
                href: href,
                autoSize: false,
                closeClick: false,
                openEffect: 'none',
                closeEffect: 'none',
                'type': 'iframe'
            }
            );
        }
        function PatientDetail(instance, td, row, col, prop, value, cellProperties) {
            //td.innerHTML = '<a target="_blank" id="aa" href="../Lab/PatientSampleinfoPopup.aspx?TestID=' + PatientData[row].Test_ID + '&LabNo=' + PatientData[row].LedgerTransactionNo + '" class="various iframe" > <img  src="../../App_Images/view.GIF" style="border-style: none" alt="">     </a>';          
            //td.innerHTML = '<img  src="../../App_Images/view.GIF" style="border-style: none;cursor:pointer;" alt="" onclick="callPatientDetail(' + "'" + '' + PatientData[row].Test_ID + "'" + ',' + "'" + '' + PatientData[row].LedgerTransactionNo + "'" + ');">     </a>';
            //td.className = PatientData[row].Status;
            //return td;
        }




        function ShowAttachment(instance, td, row, col, prop, value, cellProperties) {
            var MyStr1 = "";
            if (PatientData[row].DocumentStatus != "") {
                //  MyStr1 = MyStr1 + '<a target="_blank" id="mm"  href="../Lab/ShowAttachment.aspx?labno=' + PatientData[row].LedgerTransactionNo + '"  > <img  src="../../App_Images/attachment.png" style="border-style: none;width:20px;" alt=""></a>';
                // MyStr1 = MyStr1 + '<a target="_blank" id="mm"  href="../Lab/AddFileRegistration.aspx?labno=' + PatientData[row].LedgerTransactionNo + '"  > <img  src="../../App_Images/attachment.png" style="border-style: none;width:20px;" alt=""></a>';
                MyStr1 = MyStr1 + '<img  src="../../App_Images/attachment.png" style="border-style: none;width:20px;cursor:pointer;" alt="" onclick="callShowAttachment(' + "'" + '' + PatientData[row].LedgerTransactionNo + "'" + ');"></a>';
            }
            td.innerHTML = MyStr1;
            td.className = PatientData[row].Status;
            return td;
        }
        function Location(instance, td, row, col, prop, value, cellProperties) {
            var MyStr = ""
            if (PatientData[row].SampleLocation != '')
                td.innerHTML = MyStr + PatientData[row].SampleLocation;
            else
                td.innerHTML = MyStr;

            return td;
        }
        function AutoNumberRenderer(instance, td, row, col, prop, value, cellProperties) {
            var MyStr = '<span>' + parseInt(row + 1) + '</span>&nbsp;';//td.innerHTML   

            //alert(PatientData[row].delayimg);
            if (PatientData[row].delayimg == "1") {
                td.innerHTML = MyStr + '<img src="../../App_Images/delayimg.gif" style="width:20px; Height:25px" title="CutOff Time Delayed"/>';
            }
            else {
                td.innerHTML = MyStr;
            }


            if (((PatientData[row].Status == "Received") || (PatientData[row].Status == "MacData")) && PatientData[row].isrerun == "1") {
                $(td).parent().addClass('FullRowColorInRerun');
            }
            return td;
        }
        function EnableBarcode(instance, td, row, col, prop, value, cellProperties) {
                <%if (Util.GetString(Request.QueryString["cmd"]) == "changebarcode")
                  {%>
            cellProperties.readOnly = false;
            <%}%>
            td.innerHTML = value;
            td.className = PatientData[row].Status;
            return td;
        }
        function PrintreportRenderer(instance, td, row, col, prop, value, cellProperties) {
            if (PatientData[row].Approved == "1") {
                // var escaped = Handsontable.helper.stringify(value);
                //escaped = strip_tags(escaped, '<em><b><strong><a><big>'); //be sure you only allow certain HTML tags to avoid XSS threats (you should also remove unwanted HTML attributes)
                td.innerHTML = '<a href="labreportnew.aspx?IsPrev=1&TestID=' + PatientData[row].Test_ID + ',&Phead=0" target="_blank" > <img  src="../../App_Images/print.gif" style="border-style: none" alt="">     </a>';
                //  td.id = value.replace(/,/g, "_");
            }
            else {
                td.innerHTML = '<span>&nbsp;</span>';
            }
            td.className = PatientData[row].Status;
            return td;
        }
        // data: 'PName'
        function pname(instance, td, row, col, prop, value, cellProperties) {
            var escaped = Handsontable.helper.stringify(value);
            if (row > 0) {
                if (PatientData[row].PName != PatientData[row - 1].PName) {
                    td.innerHTML = '<div>' + PatientData[row].PName + '</div>';
                }
                else if (PatientData[row].LedgerTransactionNo != PatientData[row - 1].LedgerTransactionNo) {
                    td.innerHTML = '<div>' + PatientData[row].PName + '</div>';
                }

                else {
                    td.innerHTML = '<div></div>';
                }

            }
            else {
                td.innerHTML = '<div>' + PatientData[row].PName + '</div>';
            }
        }
        function labno(instance, td, row, col, prop, value, cellProperties) {
            var escaped = Handsontable.helper.stringify(value);
            if (row > 0) {
                if (PatientData[row].LedgerTransactionNo != PatientData[row - 1].LedgerTransactionNo) {
                    td.innerHTML = '<div>' + PatientData[row].LedgerTransactionNo + '  </div>';
                    //td.innerHTML = '<div>' + PatientData[row].LedgerTransactionNo + '<br /><img title="Old/Previous Report" src="../../App_Images/view.GIF" style="border-style: none;cursor:pointer;"  onclick="OldPatient(\'' + PatientData[row].LedgerTransactionNo + '\');">     </a></div>';
                }

                else {
                    td.innerHTML = '<div></div>';
                }

            }
            else {
                //td.innerHTML = '<div>' + PatientData[row].LedgerTransactionNo + '<br /><img title="Old/Previous Report" src="../../App_Images/view.GIF" style="border-style: none;cursor:pointer;"  onclick="OldPatient(\'' + PatientData[row].LedgerTransactionNo + '\');">     </a></div>';
                td.innerHTML = '<div>' + PatientData[row].LedgerTransactionNo + '  </div>';
            }
        }
        function barcodeno(instance, td, row, col, prop, value, cellProperties) {
            var escaped = Handsontable.helper.stringify(value);
            if (row > 0) {
                if (PatientData[row].BarcodeNo != PatientData[row - 1].BarcodeNo) {
                    td.innerHTML = '<div>' + PatientData[row].BarcodeNo + '</div>';
                }
                else {
                    td.innerHTML = '<div></div>';
                }

            }
            else {
                td.innerHTML = '<div>' + PatientData[row].BarcodeNo + '</div>';
            }
        }

        function OldPatient(LedgertransactionNo) {
            window.open('DoctorPatientLabSearch.aspx?LedgertransactionNO=' + LedgertransactionNo + ' ')
        }

        function checkboxcreate(instance, td, row, col, prop, value, cellProperties) {
            if (row > 0) {

                if (PatientData[row].test_id != PatientData[row - 1].test_id) {
                    if (PatientData[row].Approved == '0') {
                        var escaped = Handsontable.helper.stringify(value);
                        td.innerHTML = '<input type="checkbox" id="mmchk" class="mmchk"    value="' + PatientData[row].test_id + '"  data="' + PatientData[row].test_id + '" />';
                    }
                }

                else {
                    if (PatientData[row].Approved == '0') {
                        var escaped = Handsontable.helper.stringify(value);
                        td.innerHTML = "";//'<input type="checkbox" id="mmchk"    value="' + PatientData[row].test_id + '"  data="' + PatientData[row].test_id + '" />';
                    }

                }
            }
            else {


                if (PatientData[row].Approved == '0') {
                    var escaped = Handsontable.helper.stringify(value);
                    td.innerHTML = '<input type="checkbox" id="mmchk" class="mmchk"   value="' + PatientData[row].test_id + '"  data="' + PatientData[row].test_id + '" />';
                }
            }

            return td;
        }

        function colorfun(instance, td, row, col, prop, value, cellProperties) {
            if (parseFloat(PatientData[row].MinCritical) != 0 && parseFloat(PatientData[row].Value) < parseFloat(PatientData[row].MinCritical)) {

                if (parseFloat(PatientData[row].reporttype) == 1) {
                    td.innerHTML = '<a id="anchtool" style="color:black;"   >' + PatientData[row].Value + '</a>';
                    //alert(PatientData[row].Value-PatientData[row].MinCritical);
                    td.style.backgroundColor = '#deb887';
                }




            }
            else if (parseFloat(PatientData[row].Value) > parseFloat(PatientData[row].MaxCritical) && parseFloat(PatientData[row].MaxCritical) != 0) {
                if (parseFloat(PatientData[row].reporttype) == 1) {
                    td.innerHTML = '<a id="anchtool" style="color:black;"   >' + PatientData[row].Value + '</a>';
                    td.style.backgroundColor = '#ff0000';
                }
            }
            else if (parseFloat(PatientData[row].Value) > parseFloat(PatientData[row].MaxValue)) {
                td.innerHTML = '<a id="anchtool" style="color:black;"   >' + PatientData[row].Value + '</a>';
                td.style.backgroundColor = 'pink';
            }
            else if (parseFloat(PatientData[row].Value) < parseFloat(PatientData[row].MinValue)) {
                td.innerHTML = '<a id="anchtool" style="color:black;"   >' + PatientData[row].Value + '</a>';
                td.style.backgroundColor = 'yellow';
            }
            else {
                td.style.backgroundColor = 'White';
                td.innerHTML = '<a id="anchtool" style="color:black;"   >' + PatientData[row].Value + '</a>';
            }
            return td;
        }

        function Observationname(instance, td, row, col, prop, value, cellProperties) {

            //if (parseFloat(PatientData[row].Value) > parseFloat(PatientData[row].MaxValue))
            //    td.innerHTML = ' <span style="cursor:pointer;height:100px;width:100px;"  onmouseover="showdelta(' + PatientData[row].test_id + ',' + PatientData[row].LabObservation_ID + ')" onmouseout="hidedelta()"><img style="width:15px;height:15px;" src="../OnlineLab/Images/delta.png"/></span> <a id="anchtool" style="font-weight:bold;background-color:pink;"   >' + PatientData[row].Test + '</a>';
            //else if (parseFloat(PatientData[row].Value) < parseFloat(PatientData[row].MinValue))
            //    td.innerHTML = ' <span style="cursor:pointer;height:100px;width:100px;"  onmouseover="showdelta(' + PatientData[row].test_id + ',' + PatientData[row].LabObservation_ID + ')" onmouseout="hidedelta()"><img style="width:15px;height:15px;" src="../OnlineLab/Images/delta.png"/></span> <a id="anchtool" style="font-weight:bold;background-color:yellow;"   >' + PatientData[row].Test + ' </a> ';
            //else
            td.innerHTML = '<span style="cursor:pointer;height:100px;width:100px;"  onclick="showdelta(' + "'" + '' + PatientData[row].test_id + "'" + ',' + "'" + '' + PatientData[row].LabObservation_ID + "'" + ')" onmouseout="hidedelta()"><img style="width:15px;height:15px;" src="../../Images/delta.png"/></span>   <a id="anchtool" style="font-weight:bold;color:black;"   >' + PatientData[row].Test + '</a> ';
            //td.id = value.replace(/,/g, "_");
            td.style.width = '200px';
            td.style.position = 'relative';
            $(td).addClass(cellProperties.className);
        }

        function showdelta(testid, labobserid) {
            if ($('#deltadiv').is(":visible") == true) {
                $('#deltadiv').hide();
                return;
            }
            var url = "../../Design/Lab/DeltaCheck.aspx?TestID=" + testid + "&LabObservation_ID=" + labobserid;

            $('#deltadiv').load(url);
            $('#deltadiv').css({ 'top': mouseY, 'left': mouseX }).show();
        }
        function hidedelta() {
            $('#deltadiv').hide();
        }

        function tooltipfun(instance, td, row, col, prop, value, cellProperties) {
            var escaped = Handsontable.helper.stringify(value);
            if (row > 0) {
                if (PatientData[row].InvestigationName != PatientData[row - 1].InvestigationName) {
                    var oldinvestigationname = "";
                    if (parseFloat(PatientData[row].Value) > parseFloat(PatientData[row].MaxValue))

                        td.innerHTML = '<a id="anchtool" style="font-weight:bold;" onmouseover="getme(\'' + PatientData[row].colledate + '\',\'' + PatientData[row].DATE + '\',\'' + PatientData[row].ResultEnteredDate + '\', \'' + PatientData[row].ProvisionalDispatchDate + '\')" onmouseout="hideme()" >' + PatientData[row].InvestigationName + '</a>';
                    else if (parseFloat(PatientData[row].Value) < parseFloat(PatientData[row].MinValue))
                        td.innerHTML = '<a id="anchtool" style="font-weight:bold;" onmouseover="getme(\'' + PatientData[row].colledate + '\',\'' + PatientData[row].DATE + '\',\'' + PatientData[row].ResultEnteredDate + '\', \'' + PatientData[row].ProvisionalDispatchDate + '\')" onmouseout="hideme()" >' + PatientData[row].InvestigationName + '</a>';
                    else
                        td.innerHTML = '<a id="anchtool" style="font-weight:bold;" onmouseover="getme(\'' + PatientData[row].colledate + '\',\'' + PatientData[row].DATE + '\',\'' + PatientData[row].ResultEnteredDate + '\', \'' + PatientData[row].ProvisionalDispatchDate + '\')" onmouseout="hideme()" >' + PatientData[row].InvestigationName + '</a>';
                    //td.id = value.replace(/,/g, "_");
                    td.style.width = '200px';
                    td.style.position = 'relative';
                    $(td).addClass(cellProperties.className);
                }
                else if (PatientData[row].LedgerTransactionNo != PatientData[row - 1].LedgerTransactionNo) {
                    var oldinvestigationname = "";
                    if (parseFloat(PatientData[row].Value) > parseFloat(PatientData[row].MaxValue))

                        td.innerHTML = '<a id="anchtool" style="font-weight:bold;" onmouseover="getme(\'' + PatientData[row].colledate + '\',\'' + PatientData[row].DATE + '\',\'' + PatientData[row].ResultEnteredDate + '\', \'' + PatientData[row].ProvisionalDispatchDate + '\')" onmouseout="hideme()" >' + PatientData[row].InvestigationName + '</a>';
                    else if (parseFloat(PatientData[row].Value) < parseFloat(PatientData[row].MinValue))
                        td.innerHTML = '<a id="anchtool" style="font-weight:bold;" onmouseover="getme(\'' + PatientData[row].colledate + '\',\'' + PatientData[row].DATE + '\',\'' + PatientData[row].ResultEnteredDate + '\', \'' + PatientData[row].ProvisionalDispatchDate + '\')" onmouseout="hideme()" >' + PatientData[row].InvestigationName + '</a>';
                    else
                        td.innerHTML = '<a id="anchtool" style="font-weight:bold;" onmouseover="getme(\'' + PatientData[row].colledate + '\',\'' + PatientData[row].DATE + '\',\'' + PatientData[row].ResultEnteredDate + '\', \'' + PatientData[row].ProvisionalDispatchDate + '\')" onmouseout="hideme()" >' + PatientData[row].InvestigationName + '</a>';
                    //td.id = value.replace(/,/g, "_");
                    td.style.width = '200px';
                    td.style.position = 'relative';
                    $(td).addClass(cellProperties.className);

                }

                else {

                    if (parseFloat(PatientData[row].Value) > parseFloat(PatientData[row].MaxValue))
                        td.innerHTML = '<a id="anchtool" style="font-weight:bold;" onmouseover="getme(\'' + PatientData[row].colledate + '\',\'' + PatientData[row].DATE + '\',\'' + PatientData[row].ResultEnteredDate + '\', \'' + PatientData[row].ProvisionalDispatchDate + '\')"  ></a>';
                    else if (parseFloat(PatientData[row].Value) < parseFloat(PatientData[row].MinValue))
                        td.innerHTML = '<a id="anchtool" style="font-weight:bold;" onmouseover="getme(\'' + PatientData[row].colledate + '\',\'' + PatientData[row].DATE + '\',\'' + PatientData[row].ResultEnteredDate + '\', \'' + PatientData[row].ProvisionalDispatchDate + '\')"  ></a>';

                    else
                        td.innerHTML = '<a id="anchtool" style="font-weight:bold;" onmouseover="getme(\'' + PatientData[row].colledate + '\',\'' + PatientData[row].DATE + '\',\'' + PatientData[row].ResultEnteredDate + '\', \'' + PatientData[row].ProvisionalDispatchDate + '\')"  ></a>';
                    //td.id = value.replace(/,/g, "_");
                    td.style.width = '200px';
                    td.style.position = 'relative';
                    $(td).addClass(cellProperties.className);
                }
            }
            else {

                if (parseFloat(PatientData[row].Value) > parseFloat(PatientData[row].MaxValue))
                    td.innerHTML = '<a id="anchtool" style="font-weight:bold;" onmouseover="getme(\'' + PatientData[row].colledate + '\',\'' + PatientData[row].DATE + '\',\'' + PatientData[row].ResultEnteredDate + '\', \'' + PatientData[row].ProvisionalDispatchDate + '\')" onmouseout="hideme()" >' + PatientData[row].InvestigationName + '</a>';
                else if (parseFloat(PatientData[row].Value) < parseFloat(PatientData[row].MinValue))
                    td.innerHTML = '<a id="anchtool" style="font-weight:bold;" onmouseover="getme(\'' + PatientData[row].colledate + '\',\'' + PatientData[row].DATE + '\',\'' + PatientData[row].ResultEnteredDate + '\', \'' + PatientData[row].ProvisionalDispatchDate + '\')" onmouseout="hideme()" >' + PatientData[row].InvestigationName + '</a>';
                else
                    td.innerHTML = '<a id="anchtool" style="font-weight:bold;" onmouseover="getme(\'' + PatientData[row].colledate + '\',\'' + PatientData[row].DATE + '\',\'' + PatientData[row].ResultEnteredDate + '\', \'' + PatientData[row].ProvisionalDispatchDate + '\')" onmouseout="hideme()" >' + PatientData[row].InvestigationName + '</a>';
                //td.id = value.replace(/,/g, "_");
                td.style.width = '200px';
                td.style.position = 'relative';
                $(td).addClass(cellProperties.className);
            }

            return td;
        }

        var rowIndx = "";
        function PickRowData(rowIndex) {
            rowIndx = rowIndex;
            currentRow = rowIndex;
        }
        function PicSelectedRow() {
            PickRowData(rowIndx);
        }

        function PreLabObs() {
            var minRows = 0;
            if (currentRow > minRows) {
                PickRowData(currentRow - 1);

            }
            else { $('#btnPreLabObs').attr("disabled", true); }
        }
        function NextLabObs() {
            var totalRows = PatientData.length - 1;
            if (totalRows > currentRow) {
                PickRowData(currentRow + 1);
            }
            else { $('#btnNextLabObs').attr("disabled", true); modelAlert('No more rows available'); }
        }


        function LoadInvName(LabNo) {
            $.ajax({
                url: "ApproveDispatch.aspx/GetPatientInvsetigationsNameOnly",
                data: '{ LabNo:"' + LabNo + '"}', // parameter map
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {
                    InvData = result.d;
                    $('.DivInvName').html(InvData);
                    $('.DivInvName').show();
                },
                error: function (xhr, status) {
                    // modelAlert("Error.... ");
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }

        function ApproveDispatchAll() {
            if ($('#<%=ddlApprove.ClientID%>').val() == '0') {
                modelAlert("Please Select Doctor !!");
                return;
            }

            var test_id = "";
            if ($("input:checkbox[id=mmchk]:checked")) {
                $("input:checkbox[id=mmchk]:checked").each(function () {
                    test_id += "'" + $(this).val() + "',";
                });
            }

            if (test_id == "") {
                modelAlert("Please Select Test To Approve & Dispatch");
                return;
            }
            //alert(test_id);
            SaveLabObs(test_id);

        }

        //function modelAlert(msg) {
        //    $('#msgField').html('');
        //    $('#msgField').append(msg);
        //    $(".alert").css('background-color', 'red');
        //    $(".alert").removeClass("in").show();
        //    $(".alert").delay(1500).addClass("in").fadeOut(1000);
        //}


        function SaveLabObs(test_id) {

            resultStatus = "Approved"
            //   $.blockUI();
            $.ajax({
                url: "ApproveDispatch.aspx/SaveLabObservationOpdData",
                //string ApprovedBy,string ApprovalName
                data: JSON.stringify({ Testid: test_id, ResultStatus: resultStatus, ApprovedBy: (($('#<%=ddlApprove.ClientID%>').length > 0) ? $('#<%=ddlApprove.ClientID%>').val() : ''), ApprovalName: (($('#<%=ddlApprove.ClientID%>').length > 0) ? $('#<%=ddlApprove.ClientID%> :selected').text() : '') }),
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    $('.btnDiv').children().attr("disabled", "disabled");
                    criticalsave = "0";
                    macvalue = "0";
                    if (result.d == 'success') {
                        //$('#msgField').html('');
                        //$('#msgField').append('Approved and Dispatched Saved Successfully');
                        // SearchSampleCollection(this);
                        //$(".alert").css('background-color', '#04b076');
                        //$(".alert").removeClass("in").show();
                        //$(".alert").delay(1500).addClass("in").fadeOut(1000);
                        modelAlert('Approved and Dispatched Saved Successfully', function (response)
                        {
                            SearchSampleCollection(this);
                        }); 

                        var totalRows = PatientData.length - 1;
                        if (totalRows > currentRow) {

                            PickRowData(currentRow + 1);

                        }
                        else {
                            PickRowData(currentRow);
                        }
                        //   $.unblockUI();
                    }
                    else {
                        $('#msgField').html('');
                        modelAlert('Report Not Approved')
                        //$('#msgField').append('Report Not Approved');
                        //$(".alert").css('background-color', 'Red');
                        //$(".alert").removeClass("in").show();
                        //$(".alert").delay(1500).addClass("in").fadeOut(1000);
                        //   $.unblockUI();
                    }


                },
                error: function (xhr, status) {
                    var err = eval("(" + xhr.responseText + ")");
                    modelAlert(err.Message)
                    //$('#msgField').html('');
                    //$('#msgField').append(err.Message);
                    //$(".alert").css('background-color', 'red');
                    //$(".alert").removeClass("in").show();
                    //$(".alert").delay(7000).addClass("in").fadeOut(1000);
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }

        function getCurrentDateData() {
            var d = new Date()
            formattedDate = guid();
            return formattedDate;
        }

        function closeme() {
            try {
                window.opener.SearchData();
            }
            catch (e) {
            }
            this.close();
        }

    </script>
</asp:Content>
