<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" EnableEventValidation="false" CodeFile="MapInvestigationObservationNew.aspx.cs" Inherits="Design_Lab_MapInvestigationObservationNew" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    
    <link href="../../Styles/PurchaseStyle.css" rel="stylesheet" />
    <script src="../../Scripts/jquery.tablednd.js" type="text/javascript"></script>
    <script type="text/javascript" src="../../Scripts/Search.js"></script>
    <link rel="Stylesheet" href="../../Scripts/fancybox/jquery.fancybox-1.3.4.css" type="text/css" />
    <script type="text/javascript" src="../../Scripts/fancybox/jquery.fancybox-1.3.4.pack.js"></script>
    <script type="text/javascript" src="../../Scripts/fancybox/jquery.mousewheel-3.0.4.pack.js"></script>
    <link href="../../Styles/grid24.css" rel="stylesheet" />
       <script type="text/javascript">
           var ObsIdStore = "";
           var  InvIdStore = "";
           function SelectGen(InvId, ObsId) {
            $.ajax({
                url: "../Lab/Services/MapInvestigationObservation.asmx/SelectGender",
                data: '{InvestigationID: "' + InvId + '"}', // parameter map
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    var data = result.d;
                    if (data == "M") {
                        $('#<%=rblGender_popup.ClientID %> :radio[value="M"]').attr('checked', 'checked');
                        $('#<%=rblGender_popup.ClientID %> :radio[value="F"]').attr("disabled", "disabled");

                    }
                    else if (data == "F") {
                        $('#<%=rblGender_popup.ClientID %> :radio[value="F"]').attr('checked', 'checked');
                        $('#<%=rblGender_popup.ClientID %> :radio[value="M"]').attr("disabled", "disabled");

                    }
                    else {
                        $('#<%=rblGender_popup.ClientID %> :radio[value="M"]').attr('checked', 'checked');
                        $('#<%=rblGender_popup.ClientID %> input:radio').removeAttr("disabled");
                    }
                    GetObservationDetails(InvId, ObsId);
                },
                error: function (xhr, status) {
                    modelAlert(xhr.responseText);
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
    }

    function GetObsMasterData(ObsId) {
        $.ajax({
            url: "../Lab/Services/MapInvestigationObservation.asmx/GetObsMasterData",
            data: '{ObservationID: "' + ObsId + '"}', // parameter map
            type: "POST", // data has to be Posted    	        
            contentType: "application/json; charset=utf-8",
            timeout: 120000,
            dataType: "json",
            success: function (result) {
                ObsMasterData = jQuery.parseJSON(result.d);
                $('#txtObservation_popup').val(ObsMasterData[0].Name);
                $('#txtSuffix_popup').val(ObsMasterData[0].Suffix);
                if (ObsMasterData[0].Culture_flag == '1')
                    $('#chkIsCulture_popup').attr('checked', true)
                else
                    $('#chkIsCulture_popup').attr('checked', false)
            },
            error: function (xhr, status) {
                modelAlert(xhr.responseText);
                window.status = status + "\r\n" + xhr.responseText;
            }
        });
    }
    function GetObservationDetails(InvId, ObsId) {

        var Gender = $('#<%=rblGender_popup.ClientID%> input:checked').val();
        var MachineID = $('#<%=ddlMachine_popup.ClientID%>').val();
        var CentreID = $('#<%=ddlCentre_popup.ClientID%>').val();
        if (Gender == "B") {
            //  alert("In case of Both, Default Male ranges are loaded \r\n You can save these ranges for Both Male and female also !");
            modelAlert("In case of Both, Default Male ranges are loaded \r\n You can save these ranges for Both Male and female also !");
            Gender = "M";
        }

        $.ajax({
            url: "../Lab/Services/MapInvestigationObservation.asmx/GetObservationDetails",
            data: '{ ObservationID: "' + ObsId + '",InvestigationID: "' + InvId + '",Gender:"' + Gender + '",MachineID:"' + MachineID + '",CentreID:"' + CentreID + '"}', // parameter map
            type: "POST", // data has to be Posted    	        
            contentType: "application/json; charset=utf-8",
            timeout: 120000,
            dataType: "json",
            success: function (result) {
                ObsDetail = jQuery.parseJSON(result.d);
                var output = $('#tb_InvestigationItems_popup').parseTemplate(ObsDetail);
                $('#div_InvestigationItems_popup').html(output);
                $("#tb_grdLabSearch tr").find("#imgAdd,#imgRmv").hide();
                $("#tb_grdLabSearch tr:last").find("#imgAdd,#imgRmv").show();
                tableproperties();
                if (ObsDetail.length == "0") {
                    AddnewRow('1', '0');
                    $('#txtconversionfactor_popup').val('');
                    $('#txtunit_popup').val('');
                }
                else {
                    $('#txtconversionfactor_popup').val(ObsDetail[0].ConversionFactor);
                    $('#txtunit_popup').val(ObsDetail[0].ConversionFactorUnit);
                }
            },
            error: function (xhr, status) {
                modelAlert(xhr.responseText);
                window.status = status + "\r\n" + xhr.responseText;
            }
        });
    };
    </script>
    <script type="text/javascript">
        function tableproperties() {
            $("#tb_grdLabSearch_popup tr").find("#txtToAge,#txtMinCritical,#txtMaxCritical").bind('keyup blur ', function () {
                this.value = this.value.replace(/[^0-9,-,.]/g, '');

            });
            //            $("#tb_grdLabSearch tr").find("#txtToAge,#txtMinReading,#txtMaxReading,#txtMinCritical,#txtMaxCritical").bind('keyup blur ', function (e) {
            //                var c = e.keyCode;
            //                value = $(this).val();
            //                alert(value.indexOf('.'));
            //                alert(c);
            //                // Prevent insertion if the inserting character is
            //                // 1. a 'dot' but there is already one in the text box, or
            //                // 2. not numerics.
            //                if ((c == 190 && value.indexOf('.') < -1) || c < 48 || c > 57) {
            //                    e.preventDefault();
            //                    return;
            //                }
            //            });
            $("#tb_grdLabSearch_popup tr").find("#txtToAge,#txtMinCritical,#txtMaxCritical,#txtReadingFormat").bind('keypress keyup keydown  ', function () {

                while (($(this).val().split(".").length - 1) > 2) {

                    $(this).val($(this).val().slice(0, -2));

                    if (($(this).val().split(".").length - 2) > 1) {
                        continue;
                    } else {
                        return false;
                    }
                }
            });

            $("#tb_grdLabSearch_popup tr").find(':text').bind('keyup blur ', function () {
                this.value = this.value.replace(/[\"|\']/g, '');
            });

            $("#tb_grdLabSearch_popup tr").find("#txtMaxReading").blur(function () {
                if (Number(this.value) <= $(this).closest("tr").find("#txtMinReading").val())
                    this.value = '';
            });

            $("#tb_grdLabSearch_popup tr").find("#txtMaxCritical").blur(function () {
                if (Number(this.value) <= $(this).closest("tr").find("#txtMinCritical").val())
                    this.value = '';
            });
            var maxLength = 6;
            $("#tb_grdLabSearch_popup tr").find("#txtToAge,#txtMinCritical,#txtMaxCritical").bind('keypress keyup blur', function () {
                if ((this.value.length) > maxLength) {
                    $(this).val($(this).val().substr(0, this.value.length - 1));
                    return false;
                }
            });
            var maxLength1 = 50;
            $("#tb_grdLabSearch_popup tr").find("#txtReadingFormat").bind('keyup blur keypress', function () {
                if ((this.value.length) > maxLength1) {
                    $(this).val($(this).val().substr(0, this.value.length - 1));
                    return false;
                }
            });
        }
        function AddDetail() {
            var count = $("#tb_grdLabSearch_popup tr").length;
            var ToAge = $("#tb_grdLabSearch_popup").find('#tr_' + (count - 1)).find('td:eq(' + 3 + ')').find("#txtToAge").val();
            var frmAge = $("#tb_grdLabSearch_popup").find('#tr_' + (count - 1)).find('td:eq(' + 1 + ')').find("#lblFromAge").text();
            if (ToAge == "") {
                modelAlert('Please Enter Age');
                // alert('Please Enter Age');
                $("#tb_grdLabSearch_popup").find('#tr_' + (count - 1)).find('td:eq(' + 3 + ')').find("#txtToAge").focus();
                return;
            }
            var isVisible = $("#tb_grdLabSearch_popup tr:last").find('td:eq(' + 3 + ')').find("#txtToAge").is(':visible');
            if (isVisible == true && (Number(ToAge) < Number(frmAge))) {
                modelAlert('To Age Should be Greater than FromAge');
                // alert('To Age Should be Greater than FromAge');
                return;
            }
            if (ToAge > 58400) {
                modelAlert('Age Cannot Be Greater Than 180 Yrs');
                //   alert('Age Cannot Be Greater Than 180 Yrs');
                return;
            }
            if ($("#tb_grdLabSearch_popup tr:last").find('td:eq(' + 4 + ')').find("#txtMinReading").val() == "") {
                modelAlert('Please Enter Min. Reading');
                //  alert('Please Enter Min. Reading');
                $("#tb_grdLabSearch_popup tr:last").find('td:eq(' + 4 + ')').find("#txtMinReading").focus();
                return;
            }
            if ($("#tb_grdLabSearch_popup tr:last").find('td:eq(' + 5 + ')').find("#txtMaxReading").val() == "") {
                modelAlert('Please Enter Max. Reading');
                // alert('Please Enter Max. Reading');
                $("#tb_grdLabSearch_popup tr:last").find('td:eq(' + 5 + ')').find("#txtMaxReading").focus();
                return;
            }
            if ($("#tb_grdLabSearch_popup tr:last").find('td:eq(' + 4 + ')').find("#txtMinReading").val() != "" && $("#tb_grdLabSearch tr:last").find('td:eq(' + 5 + ')').find("#txtMaxReading").val()) {
                if (Number($("#tb_grdLabSearch tr:last").find('td:eq(' + 4 + ')').find("#txtMinReading").val()) >= Number($("#tb_grdLabSearch tr:last").find('td:eq(' + 5 + ')').find("#txtMaxReading").val())) {
                    modelAlert('Max Range Should be Greater than MinAge');
                    //    alert('Max Range Should be Greater than MinAge');
                    $("#tb_grdLabSearch tr:last").find('td:eq(' + 5 + ')').find("#txtMaxReading").focus();
                    return;
                }
            }
            $("#tb_grdLabSearch_popup tr:last").find("#imgAdd,#imgRmv").hide();
            $("#tb_grdLabSearch_popup tr:last").find('td:eq(' + 3 + ')').find("#lblToAge").show();
            $("#tb_grdLabSearch_popup tr:last").find('td:eq(' + 3 + ')').find("#lblToAge").text(ToAge);
            $("#tb_grdLabSearch_popup tr:last").find('td:eq(' + 2 + ')').find("#txtToAgeyears").attr('disabled', 'disabled');
            $("#tb_grdLabSearch_popup tr:last").find('td:eq(' + 3 + ')').find("#txtToAge").hide();
            var frmAgenew = $("#tb_grdLabSearch_popup tr:last").find('td:eq(' + 3 + ')').find("#lblToAge").text();
            frmAgenew = Number(frmAgenew) + 1;
            AddnewRow(count, frmAgenew);
        }
        function AddnewRow(count, frmAgenew) {
            var newRow = $('<tr />').attr('id', 'tr_' + count);
            newRow.html('<td class="GridViewLabItemStyle">' + count + '</td><td class="GridViewLabItemStyle"><span id="lblFromAge" >' + frmAgenew + '</span></td> ' +
                '<td class="GridViewLabItemStyle"><input id="txtToAgeyears" type="text" style="width: 50px" autocomplete="off" onkeyup="CalculateAgeOnDays(this)" onlynumber="3" decimalplace="2" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event)" max-value="180" /></td> ' +
                '<td class="GridViewLabItemStyle"><span id="lblToAge" /><input id="txtToAge" type="text" style="width: 50px" autocomplete="off"  /></td> ' +
                '<td class="GridViewLabItemStyle"><input id="txtMinReading" type="text" style="width: 50px" autocomplete="off"   /></td> ' +
                '<td class="GridViewLabItemStyle"><input id="txtMaxReading" type="text" style="width: 50px" autocomplete="off"   /></td> ' +
                '<td class="GridViewLabItemStyle"><input id="txtMinCritical" type="text" style="width: 50px" autocomplete="off"   /></td> ' +
                '<td class="GridViewLabItemStyle"><input id="txtMaxCritical" type="text" style="width: 50px" autocomplete="off"   /></td> ' +
                '<td class="GridViewLabItemStyle"><input id="txtReadingFormat" type="text" style="width: 50px" autocomplete="off"   /></td> ' +
                '<td class="GridViewLabItemStyle"><textarea id="txtDisplayReading" type="text" style="width: 300px" autocomplete="off" ></textarea></td> ' +
                '<td class="GridViewLabItemStyle"><input id="txtDefaultReading" style="width: 60px" autocomplete="off"   /></td> ' +
                '<td id="imgAdd" class="GridViewLabItemStyle"><img src="../../Images/ButtonAdd.png" onclick="AddDetail()" /></td> ' +
                '<td id="imgRmv" class="GridViewLabItemStyle"><img src="../../Images/Delete.gif" onclick="RmvDetail()" /></td>');
            $("#tb_grdLabSearch_popup").append(newRow);
            tableproperties();
        }
        function RmvDetail() {
            $("#tb_grdLabSearch_popup tr:last").remove();
            $("#tb_grdLabSearch_popup tr:last").find("#imgAdd,#imgRmv").show();
            $("#tb_grdLabSearch_popup tr:last").find('td:eq(' + 3 + ')').find("#txtToAge").show();
            $("#tb_grdLabSearch_popup tr:last").find('td:eq(' + 3 + ')').find("#lblToAge").hide();
        }
    </script>
    <script type="text/javascript">
        function SaveObsRanges() {
            var count = $("#tb_grdLabSearch_popup tr").length;
            var a = jQuery("#tb_grdLabSearch_popup tr:last").find('td:eq(' + 3 + ')').find("#txtToAge").val();
            var b = jQuery("#tb_grdLabSearch_popup").find('#tr_' + (count - 1)).find('td:eq(' + 1 + ')').find("#lblFromAge").text();
            //  if (a > 58400) {
            // alert('Age Cannot Be Greater Than 160 Yrs');
            // return;
            // }
            if (Number(a) < Number(b)) {
                //   alert('To Age Should be Greater than FromAge');
                modelAlert('To Age Should be Greater than FromAge');
                return;
            }
            var ObsRanges = "";
            var fromAge = jQuery("#tb_grdLabSearch_popup tr:last").find('td:eq(' + 3 + ')').find("#txtToAge").val();
            if (fromAge == "") {
                //   alert('Age Cannot Be Blank')
                modelAlert('Age Cannot Be Blank');
                return;
            }
            if ($("#txtSuffix_popup").val().length > 1) {
                modelAlert('Suffix Lenght Cannot Be More Then 1');
                //  alert("Suffix Lenght Cannot Be More Then 1");
                return;
            }
            $("#tb_grdLabSearch_popup tr:last").find('td:eq(' + 3 + ')').find("#txtToAge").hide();
            $("#tb_grdLabSearch_popup tr:last").find('td:eq(' + 3 + ')').find("#lblToAge").text(fromAge);


            $("#tb_grdLabSearch_popup tr").each(function () {
                if ($(this).closest("tr").attr("id") != "" && $(this).closest("tr").attr("id") != undefined) {
                    var $rowid = $(this).closest("tr");
                    ObsRanges += $rowid.find("#lblFromAge").text() + '|' + $rowid.find("#lblToAge").text() + '|' + $rowid.find("#txtMinReading").val() + '|' + $rowid.find("#txtMaxReading").val() + '|' + $rowid.find("#txtMinCritical").val() + '|' + $rowid.find("#txtMaxCritical").val() + '|' + $rowid.find("#txtReadingFormat").val() + '|' + $rowid.find("#txtDisplayReading").val() + '|' + $rowid.find("#txtDefaultReading").val() + '|' + $('#txtconversionfactor_popup').val() + '|' + $('#txtunit_popup').val() + '#';
                }
            });
            $.ajax({
                url: "../Lab/Services/MapInvestigationObservation.asmx/ObservationExists",
                data: '{ ObservationName: "' + $('#txtObservation_popup').val() + '", ObservationID: "' + ObsIdStore + '"}',
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    if (result.d == "1") {
                        modelAlert('Observation Already Exist', function () { 
                            SaveRanges(ObsRanges);
                        });
                        // alert('Observation Already Exist');
                        return;
                    }
                    else if (result.d == "0") {
                        SaveRanges(ObsRanges);
                    }
                    else {
                        SaveRanges(ObsRanges);
                    }

                },
                error: function (xhr, status) {
                    alert("Error ");
                    $('input').attr('disabled', false);
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });

        }

        function SaveRanges(ObsRanges) {

            var Gender = jQuery('#<%=rblGender_popup.ClientID%> :checked').val();

            if (Gender == "B") {
                var Genderval = "M,F";
                Gender = Genderval.split(',');
            }

            var MachineID = jQuery('#<%=ddlMachine_popup.ClientID%>').val();


            for (var i = 0; i < Gender.length; i++) {

                $('input').attr('disabled', true);
                var IsCulture = '0';
                if (jQuery('#chkIsCulture_popup').attr('checked'))
                    IsCulture = '1';

                var dataobservation = {
                    ObservationName: jQuery('#txtObservation_popup').val(),
                    ObservationID: ObsIdStore,
                    InvestigationID: InvIdStore,
                    ObsRangeData: ObsRanges,
                    Gender: Gender[i],
                    Suffix: jQuery('#txtSuffix_popup').val(),
                    IsCulture: IsCulture,
                    MachineID: MachineID,
                    CentreID: jQuery('#ddlCentre_popup').val(),
                    AllCentre: jQuery('#chkAllCentre').is(':checked') ? "1" : "0"
                }
                $.ajax({
                    url: "../Lab/Services/MapInvestigationObservation.asmx/updtObsRanges",
                    data: JSON.stringify(dataobservation), // parameter map
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        var data = result.d;
                        if (data == "1") {
                            //alert('Record Saved Successfully');
                            modelAlert('Record Saved Successfully', function () {
                                // jQuery("#tb_grdLabSearch_popup tr").remove();
                                jQuery('input').attr('disabled', false);
                                window.close();
                                //   $('#EditObservation').hide(); 
                              
                            });
                        }
                        if (data == "0") {
                            //  alert('Record Not saved');
                            modelAlert('Record Not saved');
                            $('input').attr('disabled', false);
                        }
                    },
                    error: function (xhr, status) {
                        modelAlert("Error ");
                        jQuery('input').attr('disabled', false);
                        window.status = status + "\r\n" + xhr.responseText;
                    }
                });

            }
        }
    </script> 
        <style type="text/css">
        #btnSave_popup {
            height: 26px;
          background-color: #018eff;
          color:white;
        }

        .auto-style1 {
            width: 159px;
        }

        .auto-style2 {
            width: 68px;
        }
    </style>
    <script type="text/javascript">
        jQuery(document).ready(function () {
            BindSampleType();
            jQuery('#<%=ddlObservation.ClientID%>').chosen();
            jQuery('#<%=ddlInvestigation.ClientID%>,#<%=ddlDepartment.ClientID%>,#<%=cmbDept.ClientID%>,#<%=ddlGroupHead.ClientID%>').chosen();
            jQuery('#ctl00_ContentPlaceHolder1_ddlDepartment_chosen').css('width', '300px');
            jQuery('#cmbDept_chosen,#ddlGroupHead_chosen').css('width', '189px');
            var LoginType = '<%= Session["LoginType"].ToString() %>';
	        if (LoginType.toUpperCase() == "LABORATORY") {
	            //jQuery("#<%=ddlReportType.ClientID %> option").remove();
	            //jQuery("#<%=ddlReportType.ClientID %>").append(jQuery("<option></option>").val('1').html('Path Numeric'));
	            //jQuery("#<%=ddlReportType.ClientID %>").append(jQuery("<option></option>").val('3').html('Path RichText'));
	            jQuery("#btnAdd").removeAttr('disabled');
	            jQuery("#btnAddNewObs").removeAttr('disabled');

	            jQuery("#<%=ddlType.ClientID %> option").remove();
	            jQuery("#<%=ddlType.ClientID %>").append(jQuery("<option></option>").val('R').html('Sample Required'));
	            jQuery("#<%=ddlType.ClientID %>").append(jQuery("<option></option>").val('N').html('Sample Not Required'));



	        }
            if (LoginType.toUpperCase() == "RADIOLOGY") {
                //jQuery("#<%=ddlReportType.ClientID %> option").remove();
	            //jQuery("#<%=ddlReportType.ClientID %>").append(jQuery("<option></option>").val('5').html('Radiology'));

	            jQuery("#<%=ddlType.ClientID %> option").remove();
	            jQuery("#<%=ddlType.ClientID %>").append(jQuery("<option></option>").val('R').html('Acceptance Required'));
	            jQuery("#<%=ddlType.ClientID %>").append(jQuery("<option></option>").val('N').html('Acceptance Not Required'));

	            showType();
	            jQuery("#<%=ddlSample.ClientID%>").prop("selectedIndex", 0).attr("disabled", true);
	            jQuery("#btnAdd").attr('disabled', true);
	            jQuery("#btnAddNewObs").attr('disabled', true);

            }
            if (jQuery("#tb_grdLabSearch  tr").length == "0") {
                jQuery("#btnSave").attr('disabled', true);
                jQuery("#div_InvestigationItems").hide();
            }
            else {
                jQuery("#btnSave").removeAttr('disabled');
                jQuery("#div_InvestigationItems").show();
            }
            jQuery(':text').bind('keydown keyup', function () {
                if (this.value != '' && this.value.match(/[\"|\']/g)) {
                    this.value = this.value.replace(/[\"|\']/g, '');
                }
            });
            jQuery("#<%=txtInv.ClientID %>").attr('disabled', true);

        });
        function showdiv() {
            $('#pnlSave').show();
            $('#cptcode1').hide();
            $('#cptcode2').hide();
        }
    </script>
    <Ajax:ScriptManager ID="sm1" runat="server" />
    <div id="Pbody_box_inventory">

        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Investigation and Observation Relation<br />
            </b>
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Select Investigation
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Investigation
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-10">
                            <asp:DropDownList ID="ddlInvestigation" runat="server" onchange="BindObsGrid()" onkeypress="AddInvestigation(this,event);">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                           <%-- <asp:Button ID="btnNewInvestigation" runat="server" UseSubmitBehavior="false" OnClientClick="return false;"
                                Text="Manage Investigation" CssClass="ItDoseButton" />--%>
                            <input type="button" onclick="showdiv();"  id="btnNewInvestigation" value="Manage Investigation"/>
                        </div>

                        <div style="display: none;" class="col-md-3" id="cptcode1">
                            <label class="pull-left">
                                CPT Code:
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div style="display: none;" class="col-md-5" id="cptcode2">
                            <asp:TextBox ID="txtSearch" runat="server" Width="89px" AutoCompleteType="disabled"></asp:TextBox>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Mapped Observation
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Map Observation
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-10">
                            <asp:DropDownList ID="ddlObservation" runat="server"></asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <input id="btnAdd" type="button" value="Map Observation" onclick="AddObs()" class="ItDoseButton" />
                        </div>
                        <div class="col-md-3">
                            <input id="btnAddNewObs" type="button" value="Create New Observation" onclick="AddNewObs()" class="ItDoseButton" />
                        </div>
                        <div class="col-md-3">
                            <asp:Button ID="btnNewObs" runat="server" Text="New Observation" CssClass="ItDoseButton"
                                Style="display: none" />
                        </div>
                    </div>

                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div id="div_InvestigationItems" style="max-height: 450px; text-align: center; overflow-y: auto; overflow-x: hidden;">
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="padding-top: 2px; padding-bottom: 2px; text-align: center;">

            <input id="btnSave" type="button" value="Save Mapping" class="ItDoseButton" onclick="saveMapping()" />
        </div>
    </div>
    <div id="pnlSave" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content" style="background-color: white; width: 1250px; height: 545px;">
                <div class="modal-header">
                    <button class="close" data-dismiss="pnlSave" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Manage Investigations</h4>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-5">
                            <input id="chkNewInv" type="checkbox"> New Investigation
                        </div>
                         <div class="col-md-3"> 
                                <label class="pull-left">Department  </label>
                                <b class="pull-right">:</b>
                            </div>
                         <div class="col-md-5">
                             <asp:DropDownList ID="ddlDepartment" runat="server" onChange="BindListBox(this.value);" Style="width: 300px">
                            </asp:DropDownList>
                        </div>
                    </div> 
                    <div class="row">
                        <div class="col-md-5">
                            <fieldset style="padding-left: 5px; width: 285px;">
                                <asp:RadioButtonList ID="rblSearchType" runat="server" RepeatDirection="Horizontal"
                                    RepeatLayout="Flow" onclick="clearSearch()">
                                    <asp:ListItem Value="1">Code</asp:ListItem>
                                    <asp:ListItem Selected="True" Value="2">First Name</asp:ListItem>
                                    <asp:ListItem Value="3"> InBetween</asp:ListItem>
                                </asp:RadioButtonList>
                                <asp:TextBox ID="txtInvSearch" runat="server" Width="236px" AutoCompleteType="Disabled"></asp:TextBox>
                                <legend>Investigations</legend>
                                <asp:ListBox ID="lstInvestigation" runat="server" Height="330px" onChange="loadDetail(this.value);"
                                    Width="240px"></asp:ListBox>
                            </fieldset>
                        </div>
                        <div class="col-md-8" style="padding-left: 48px;width: 972px;">
                            <fieldset style="    height: 401px;" >
                            <legend>Detail</legend>
                                <div class="row">
                            <div class="col-md-5"> 
                                <label class="pull-left">Sub.Dept  </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-8">
                                <asp:DropDownList ID="ddlGroupHead" runat="server" ToolTip="Select Department" Width="189px" ClientIDMode="Static">
                                </asp:DropDownList>
                            </div>
                             <div class="col-md-5"> 
                                <label class="pull-left">Investigation  </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-6">
                             <asp:TextBox ID="txtInv" runat="server"  CssClass="requiredField" onkeypress="return check(event)"
											onkeyup="validatespace();" Font-Bold="true" MaxLength="100" ToolTip="Enter Investigation"
											Width="189px" AutoCompleteType="Disabled"></asp:TextBox>
                            </div>
                                </div>
                                   <div class="row">
                              <div class="col-md-5"> 
                                <label class="pull-left">Description  </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-8">
                           <asp:TextBox ID="txtDescription" runat="server"  onkeypress="return check(event)"
											onkeyup="validatespace();" Font-Bold="true" MaxLength="100" ToolTip="Enter Description"
											Width="189px" AutoCompleteType="Disabled"></asp:TextBox>
                            </div>
                                 <div class="col-md-5"> 
                                <label class="pull-left">Method  </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-6">
                           <asp:TextBox ID="txtPrinciple" runat="server"  onkeyup="validatespace();"
											onkeypress="return check(event)" Font-Bold="true" MaxLength="50" ToolTip="Enter Principle"
											Width="189px" AutoCompleteType="Disabled"></asp:TextBox>
                            </div>
                                       </div>
                                  <div class="row">
                             <div class="col-md-5"> 
                                <label class="pull-left">Gender  </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-8">
                          <asp:DropDownList ID="ddlGender" runat="server" ToolTip="Select Gender" Width="189px">
											<asp:ListItem Value="B">Both</asp:ListItem>
											<asp:ListItem Value="M">Male</asp:ListItem>
											<asp:ListItem Value="F">Female</asp:ListItem>
										</asp:DropDownList>
                            </div>
                               <div class="col-md-5"> 
                                <label class="pull-left">Report Type  </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-6">
                         <asp:DropDownList ID="ddlReportType" runat="server" ToolTip="Select Report Type"
											onchange="showType();" Width="189px">
											<asp:ListItem Value="1">Path Numeric</asp:ListItem>
											<asp:ListItem Value="3">Path RichText</asp:ListItem>
											<asp:ListItem Value="5">Radiology </asp:ListItem>
                                            <asp:ListItem Value="7">Culture Report</asp:ListItem>
										</asp:DropDownList>
                            </div>
</div>
                                  <div class="row">
                               <div class="col-md-5"> 
                                <label class="pull-left">Type  </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-8">
                         <asp:DropDownList ID="ddlType" runat="server" onchange="hide()" ToolTip="Select Type" Width="189px">
											<asp:ListItem Value="R">Sample Required</asp:ListItem>
											<asp:ListItem Value="N">Sample Not Required</asp:ListItem>
										</asp:DropDownList>
                            </div>

                               <div class="col-md-5"> 
                                <label class="pull-left"><label class="labelForTag"  visible="false">
											Print Sequence :&nbsp;</label>  </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-6">
                         <asp:TextBox ID="txtPrintSequence" runat="server" ToolTip="Enter Print Sequence"
										   Width="189px" MaxLength="5" AutoCompleteType="Disabled"></asp:TextBox>
										<cc1:FilteredTextBoxExtender ID="ftbeprint" runat="server" FilterType="Numbers" TargetControlID="txtPrintSequence">
										</cc1:FilteredTextBoxExtender>
                            </div>
  </div>
                                  <div class="row">
                               <div class="col-md-5"> 
                                <label class="pull-left">Sample Type  </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-8">
                          <asp:DropDownList ID="ddlSample" CssClass="required" runat="server" Width="189px" ToolTip="Select Sample Type" ClientIDMode="Static">
										</asp:DropDownList>
								   <%--  <asp:Label ID="lblSample" ClientIDMode="Static" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>--%>
                            </div>

                               <div class="col-md-5"> 
                                <label class="pull-left">Sample Con.  </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-6">
                         <asp:DropDownList ID="ddlSampleContainer"  runat="server" Width="189px" ToolTip="Select Sample Type" ClientIDMode="Static">
                                            <asp:ListItem Value="1">Normal</asp:ListItem>
                                            <asp:ListItem Value="7">Container/Block/Slide</asp:ListItem>
                                            <asp:ListItem Value="8">Container/Block</asp:ListItem>
										</asp:DropDownList>
                            </div>  
                                      </div>    
                                  <div class="row">        
                                <div class="col-md-5"> 
                                <label class="pull-left">Department  </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-8">
                         <asp:DropDownList ID="cmbDept" runat="server" TabIndex="8"
								Width="189" ToolTip="Select Department" class="requiredField" ClientIDMode="Static">
							</asp:DropDownList>
                            </div>
                            
                            <div class="col-md-5"> 
                                <label class="pull-left">IsDiscountable  </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-6">
                         Yes <input id="rdoIsDisYes" type="radio" name="rdoIsDis" value="1" />
									No <input id="rdoIsDisNo" type="radio" name="rdoIsDis" value="0" checked="checked" />
                            </div>
                                        </div>
                                  <div class="row">
                                  <div class="col-md-5"> 
                                <label class="pull-left">CPT Code  </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-8">
                           <asp:TextBox ID="txtCptcode" runat="server" MaxLength="20" Width="189px" AutoCompleteType="Disabled"></asp:TextBox> 
								   <%--  <asp:Label ID="lblSample" ClientIDMode="Static" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>--%>
                            </div>
<div class="col-md-5"> 
                                <label class="pull-left">Rate Editable  </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-6">
                      Yes <input id="rdoRateYes" type="radio" name="rdoRate" value="1" />
					  No   <input id="rdoRateNo" type="radio" name="rdoRate" value="0" checked="checked" />
                            </div>
                          
                                </div>
                                <div  class="row">
                                      <div class="col-md-5" style="text-align:center;">
                                         <b class="pull-left"> Ohter Information </b>
                                          </div>
                                </div>
                                 
                                 
                                <div class="row">
                                 
                                </div>
                                <div class="row">         
                                  <div class="col-md-18" style="padding-left: 195px;" > 
                               <asp:CheckBox ID="chkShowPtRpt" runat="server" Text="Show Name in Patient Report "  Checked="true" ClientIDMode="Static"/>
                            </div>  
                                      <div class="col-md-5">
                       <asp:CheckBox ID="ChkIsUrgent" runat="server"  ClientIDMode="Static"/> <%--Text="Urgent"--%>  Urgent
                                    </div>
                                </div>
                                 <div class="row">  
                            <div class="col-md-18" style="padding-left: 195px;"> 
                                 <asp:CheckBox ID="chkShowOnlineRpt" runat="server" Text="Show in Online Report"  Checked="true" ClientIDMode="Static"/>
                                 
                            </div>
                                      <div class="col-md-5"> 
                                      <asp:CheckBox runat="server"  ID="chkActive" ClientIDMode="Static"/> <%--Text="Yes"--%> Active
                                       
                                     </div>
                                     </div>
                                   <div class="row">  
                            <div class="col-md-18" style="padding-left: 195px;"> 
                                 <asp:CheckBox ID="chkPrintSeparate" runat="server" Text="Print Separate" ClientIDMode="Static"/>
                            </div>
                                        <div class="col-md-5"> 
                                   <asp:CheckBox runat="server"  ID="chkOutsource" ClientIDMode="Static"/>  <%--Text="Yes"--%>    Outsource 
                            </div>
                                     </div>
                                   <div class="row">  
                            <div class="col-md-15" style="padding-left: 195px;">
                                <asp:CheckBox ID="chkPrintSampleName" runat="server" Text="PrintSampleName" ClientIDMode="Static"/>
                            </div>
</div>
          <div class="row">  
                            <div class="col-md-8" style="padding-left: 195px;"> 
                                           <asp:CheckBox ID="chkIsCulture" runat="server" Text="IsCulture" ClientIDMode="Static"/> 
                            </div>  

          </div>

                                     				<div class="row">
								<div id="Div3" runat="server" style="clear: both; display: none;">
									<label class="labelForTag" style="width: 100px" visible="false">
										Investigation_ID :</label>
									<asp:TextBox ID="txtInvestigation_ID" runat="server" CssClass="ItDoseTextinputText"
										MaxLength="200"></asp:TextBox>
									<br />
									<br />
									<label class="labelForTag" style="width: 100px" visible="false">
										ItemID :</label>
									<asp:TextBox ID="txtItemID" runat="server" CssClass="ItDoseTextinputText" MaxLength="200"></asp:TextBox>
									<br />
									<br />
									<label class="labelForTag" style="width: 100px">
										Print Sequence :</label><asp:TextBox ID="txtPrintSeq" runat="server" CssClass="ItDoseTextinputText"
											MaxLength="20" Width="85px"></asp:TextBox>
									<br />
									<br />
									<label class="labelForTag" style="width: 100px" visible="false">
										Investigation_ObservationType_ID :</label><asp:TextBox ID="txtInvestigation_ObservationType_ID"
											runat="server" CssClass="ItDoseTextinputText" MaxLength="20"></asp:TextBox>
								</div>
							</div>
                               
                        </fieldset>
                        </div>
                    </div>
                </div> 
                 <div class="modal-footer" style="text-align:center;">
                                     <input id="btnAddInv" type="button" value="Save" onclick="SaveInvestigation()" class="ItDoseButton" /> 
                                </div>
            </div>
        </div>
    </div>
 
    <div id="divpnlNewObs"   class="modal fade">
		<div class="modal-dialog">
			<div class="modal-content" style="background-color:white;width: 360px;height: 159px;">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="divpnlNewObs" aria-hidden="true">&times;</button>
					<h4 class="modal-title">New Observation</h4>
				</div>
				<div class="modal-body">
					 				<div class="row">
                    <div class="col-md-11">
                    
                         <label class="pull-left">Add Observation </label>
                            <b class="pull-right">:</b>    
                    </div>
                    <div class="col-md-5">
						<asp:TextBox ID="txtObservation" CssClass="requiredField" runat="server" Width="180px" MaxLength="70"></asp:TextBox>
                    </div>
				</div>
			 	<div class="row">
                    <div class="col-md-11">
                    
                         <label class="pull-left">Suffix </label>
                            <b class="pull-right">:</b>    
                    </div>
                    <div class="col-md-5">
						<asp:TextBox ID="txtObsSuffix"    runat="server" Width="180px" MaxLength="70"></asp:TextBox>  
                    </div>
				</div> 
				</div>
				  <div class="modal-footer">
						 <input id="btnAddObs" type="button" value="Save" onclick="AddnewObservation()" class="ItDoseButton"  />
						 <button type="button"  data-dismiss="divpnlNewObs" aria-hidden="true" >Close</button>
				</div>
			</div>
		</div>
	</div>

    <div id="EditObservation" class="modal fade" >
	<div class="modal-dialog">
		<div class="modal-content" style="width:1200px;">
			<div class="modal-header">
				<button type="button" class="close"  onclick="EditObservation()"   data-dismiss="EditObservation" aria-hidden="true">&times;</button>
				<h4 class="modal-title">Edit Observation Detail</h4>
			</div>
			<div class="modal-body">
				 <div class="row">
					    <asp:RadioButtonList ID="rblGender_popup" runat="server" RepeatDirection="Horizontal"  >
                     <asp:ListItem Selected="True" Value="M">Male</asp:ListItem>
                    <asp:ListItem Value="F">Female</asp:ListItem>
                    <asp:ListItem Value="B">BOTH</asp:ListItem>
                </asp:RadioButtonList>
				 </div>
                <div class="row Purchaseheader"> 
                Observation Details 
                </div>
				  <div class="row">
                      
					  
					 <div class="col-md-4">
                            <label class="pull-left">Observation Name</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                           <input id="txtObservation_popup" type="text" style="width: 203px"  maxlength="50"/>
                           <input id="chkIsCulture_popup" type="checkbox" style="display: none;" />
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">Suffix  </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input id="txtSuffix_popup" type="text" style="width: 203px" maxlength="6"/>
                        </div>  
				 </div>

				  <div class="row" Style="display:none">  
                         <div class="col-md-4">
                            <label class="pull-left"> Conversion Factor  </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtconversionfactor_popup" maxlength="10" style="width:203px" />
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">Unit  </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtunit_popup" style="width:203px"  />
                        </div> 
                </div> 

				   <div class="row"> 
                         <div class="col-md-4">
                            <label class="pull-left">Machine Name </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                           <asp:DropDownList ID="ddlMachine_popup" runat="server" ClientIDMode="Static" Width="203px"></asp:DropDownList>
                        </div>
                           <div class="col-md-4">
                            <label class="pull-left">Centre Name </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                          <asp:DropDownList ID="ddlCentre_popup" runat="server"  Width="203px" ClientIDMode="Static"></asp:DropDownList>
                        </div>
                        <div class="col-md-3"> For All Centre<input id="chkAllCentre" type="checkbox" /></div>
                       
				 </div>

				 <div class="row Purchaseheader">
					 Observation Ranges
				 </div>
                <div class="row">
                            <div id="div_InvestigationItems_popup" style="max-height: 600px; width:100%; overflow-y: auto; overflow-x: auto;
                text-align: center;">
            </div>
                </div>


				<div style="text-align:center" class="row">
					
                    <div style="display:none">
                <table>
                    <tr>
                        <td class="auto-style1" style="text-align:right">
                            Enter Years :&nbsp;
                        </td>
                        <td>
                            <input id="txtyears_popup"  style="width:50px;" type="text" maxlength="5" size="6" onkeyup="CalculateDays()" />
                        </td>
                         <td class="auto-style2">
                            <span id="lblFromAge_popup">Days :&nbsp;</span>
                        </td>
                        <td class="auto-style2" style="text-align:left">
                            <span id="spndays_popup"></span>
                        </td>
                    </tr>
                </table>
            </div>
				</div> 
			</div>
			<div class="modal-footer" style="text-align:center;"> 
                 <input id="btnSave_popup" type="button" value="Save Ranges" onclick="SaveObsRanges()" class="ItDoseButton"/>
			</div>
		</div> 
	</div>
</div>
    <script type="text/javascript"> 
        function CalculateDays() {
            if ($('#txtyears_popup').val() > 0) {
                var Days = (($('#txtyears_popup').val()) * 365);
                $('#spndays_popup').text(Days);
            }
            else
                $('#spndays_popup').text(' ');
        }
        function CalculateAgeOnDays(el) {
            debugger;
            //if ($(el).closest('tr').find("#lblToAge").text() == "") {
            if ($(el).closest('tr').find('#txtToAgeyears').val() != "") {
                var Days = ($(el).closest('tr').find('#txtToAgeyears').val() * 365);
                //alert(Days);
                $(el).closest("tr").find("#txtToAge").val(Days);
            }
            else
                $(el).closest("tr").find("#txtToAge").val('');
            // }
        }

    </script>
	<script id="tb_InvestigationItems" type="text/html">
		<table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_grdLabSearch" 
	style="border-collapse:collapse;width:100%">
		<tr class="nodrop" style="cursor:crosshair" id="obsHeader">
			<th class="GridViewHeaderStyle" scope="col" style="width:20px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:50px;">Parent ID</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:200px;">Observation Name</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:50px;">Prefix</th>           
			<th class="GridViewHeaderStyle" scope="col" style="width:150px;">Method</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:20px;">Header</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:20px;">Critical</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:20px;">Bold</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:20px;">UnderLine</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:20px;">Microscopy</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:20px;">Parent ID</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:20px;">Edit</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:20px;">Remove</th>	
</tr>
	   <#      
			  var dataLength=obsData.length;
			  window.status="Total Records Found :"+ dataLength;
			  var objRow;   
		for(var j=0;j<dataLength;j++)
		{
		objRow = obsData[j];        
			#>
					<tr id="<#=objRow.LabObservation_ID#>"  >
<td class="GridViewLabItemStyle" onmouseover="chngcurmove()"><#=j+1#></td>
<td class="GridViewLabItemStyle" onmouseover="chngcurmove()" id="tdObsid" ><#=objRow.ObsID#></td>			   
<td class="GridViewLabItemStyle" onmouseover="chngcurmove()" id="ObsName" ><#=objRow.ObsName#></td>
	 
<td class="GridViewLabItemStyle" onmouseover="chngcurmove()"><input id="txtPrefix" type="text" value="<#=objRow.Prefix#>"  maxlength="1"/></td>

<td class="GridViewLabItemStyle" onmouseover="chngcurmove()"><input id="txtMethod" type="text" value="<#=objRow.MethodName#>"  maxlength="100"/></td>
<td class="GridViewLabItemStyle"  >
	<input id="chkHeader" type="checkbox" onmouseover="chngcur()"
<#
	   if(objRow.Child_Flag==1)
		   { #> checked='checked'   <#}#>
	/></td>                   
<td class="GridViewLabItemStyle">
	<input id="chkCritical" type="checkbox" onmouseover="chngcur()" 
 <# if(objRow.IsCritical==1)
		   {#> checked='checked'    <#}#>
 /></td>
<td class="GridViewLabItemStyle">
	<input id="chkBold"  type="checkbox" onmouseover="chngcur()"  
<# if(objRow.IsBold==1)
		   { #> checked='checked'   <#}#>
  /></td>
	<td class="GridViewLabItemStyle">
		 <input id="chkUnderLine" type="checkbox" onmouseover="chngcur()"
 <# if(objRow.IsUnderLine==1)
		   { #> checked='checked' <#}#>     
   /></td>
<td class="GridViewLabItemStyle" style="display:none">
		 <input id="chkComment" type="checkbox" onmouseover="chngcur()"
 <# if(objRow.IsComment==1)
		   { #> checked='checked' <#}#>     
   /></td>
                        <td class="GridViewLabItemStyle">
		 <input id="chkMicroscopy" type="checkbox" onmouseover="chngcur()" 
 <# if(objRow.IsMicroScopy==1)
		   { #> checked='checked' <#}#>    
   /></td>
<td class="GridViewLabItemStyle">
    <input id="txtParentid" type="text" value="<#=objRow.ParentID#>"  maxlength="10"/>
		 </td>
<td  class="GridViewLabItemStyle"><img id="imgEdit" src="../../Images/ButtonAdd.png"   onmouseover="chngcur()"/></td>
<td class="GridViewLabItemStyle" align="center"><img id="imgRmv" src="../../Images/Delete.gif" onmouseover="chngcur()" /></td>
<#}#>
</tr>            
	 </table>    
	</script>

	<script type="text/javascript">
	    function saveobs(ObsID) {
	        jQuery("#<%=lblMsg.ClientID %>").text('');
	        jQuery.ajax({
	            url: "../Lab/Services/MapInvestigationObservation.asmx/SaveObservation",
	            data: '{ InvestigationID: "' + jQuery("#<%=ddlInvestigation.ClientID %>").val() + '",ObservationId:"' + ObsID + '"}', // parameter map
	            type: "POST", // data has to be Posted    	        
	            contentType: "application/json; charset=utf-8",
	            timeout: 120000,
	            async: false,
	            dataType: "json",
	            success: function (result) {
	                Data = (result.d);
	                if (Data == "1")
	                 //   jQuery("#<%=lblMsg.ClientID %>").text('Observation Saved Successfully');
	                modelAlert('Observation Saved Successfully');
	                else
	                   // jQuery("#<%=lblMsg.ClientID %>").text('Record Not Saved ');
	                    modelAlert('Record Not Saved');
	                if (jQuery("#tb_grdLabSearch  tr").length == "1") {
	                    jQuery("#btnSave").attr('disabled', true);
	                    jQuery("#div_InvestigationItems").hide();
	                }
	                else {
	                    jQuery("#btnSave").removeAttr('disabled');
	                    jQuery("#div_InvestigationItems").show();
	                }
	            },
	            error: function (xhr, status) {
	               // jQuery("#<%=lblMsg.ClientID %>").text('Error occurred, Please contact administrator');
	                modelAlert('Error occurred, Please contact administrator');
	            }
	        });

            }
            function RemoveObs(ObsId) {
                jQuery.ajax({
                    url: "../Lab/Services/MapInvestigationObservation.asmx/RemoveObservation",
                    data: '{ InvestigationID: "' + jQuery("#<%=ddlInvestigation.ClientID %>").val() + '",ObservationId:"' + ObsId + '"}', // parameter map
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        if (result.d == "1") {
                            jQuery("#" + ObsId).remove();
                            // jQuery("#<%=lblMsg.ClientID %>").text('Record Removed Successfully');
                            modelAlert('Record Removed Successfully');
                        }
                        if (jQuery("#tb_grdLabSearch  tr").length == "1") {
                            jQuery("#btnSave").attr('disabled', true);
                            jQuery("#div_InvestigationItems").hide();
                        }
                        else {
                            jQuery("#btnSave").removeAttr('disabled');
                            jQuery("#div_InvestigationItems").show();
                        }
                    },
                    error: function (xhr, status) {
                        jQuery("#<%=lblMsg.ClientID %>").text('Error occurred, Please contact administrator');
                    }
                });
                }
	</script>
	
	<script type="text/javascript">
	    function hide() {
	        jQuery("#ddlSample").chosen('destroy').css('width', '189px');
	        if (jQuery("#<%=ddlType.ClientID%>").val() == "N") {
	            jQuery("#<%=ddlSample.ClientID%>").val(0).removeClass('required').attr("disabled", true);
	        }
	        else {
	            jQuery("#<%=ddlSample.ClientID%>").val(0).addClass('required').attr("disabled", false);
	        }
            jQuery("#ddlSample").chosen().css('width', '189px');
        }
        function showType() {
            // debugger;
            jQuery("#ddlSample").chosen('destroy').css('width', '189px');
            if (jQuery("#<%=ddlReportType.ClientID%>").val() == "5") {
                jQuery("#<%=ddlType.ClientID %> option").remove();
                jQuery("#<%=ddlType.ClientID %>").append(jQuery("<option></option>").val('R').html('Acceptance Required'));
                jQuery("#<%=ddlType.ClientID %>").append(jQuery("<option></option>").val('N').html('Acceptance Not Required'));
                jQuery("#ddlSample").val(0).removeClass('required').attr('disabled', true);
                jQuery('#ddlSampleContainer').val(1).attr('disabled', true);
            }
            else {
                jQuery("#<%=ddlType.ClientID %> option").remove();
                jQuery("#<%=ddlType.ClientID %>").append(jQuery("<option></option>").val('R').html('Sample Required'));
                jQuery("#<%=ddlType.ClientID %>").append(jQuery("<option></option>").val('N').html('Sample Not Required'));
                jQuery("#<%=ddlSample.ClientID%>").val(0).attr("disabled", false).addClass('required');
                jQuery('#ddlSampleContainer').val(1).attr('disabled', false);
            }
            jQuery("#ddlSample").chosen().css('width', '189px');
        }
	</script>
	<script type="text/javascript">
	    function AddnewObservation() {
	        if (jQuery("#<%=txtObservation.ClientID%>").val() == "") {
	            modelAlert('Observation Name Cannot be Blank');
	            return;
	        }
	        if (jQuery("#<%=txtObsSuffix.ClientID%>").val().length > 6) {
	            modelAlert('Suffix Lenght Cannot Be More Then 6');
	            return;
	        }
	        jQuery.ajax({
	            url: "../Lab/Services/MapInvestigationObservation.asmx/SaveNewObservation",
	            data: '{ ObsName: "' + jQuery("#<%=txtObservation.ClientID %>").val() + '",Suffix: "' + jQuery("#<%=txtObsSuffix.ClientID %>").val() + '"}', // parameter map
	            type: "POST",
	            contentType: "application/json; charset=utf-8",
	            timeout: 120000,
	            dataType: "json",
	            async: false,
	            success: function (result) {
	                if (result.d == "0") {
	                    modelAlert('Observation Already Exist');
	                    return;
	                }
	                else if (result.d == "1") {
	                    modelAlert('Error');
	                    // alert("Error ");
	                }
	                else {
	                    $('#divpnlNewObs').hide();
	                    saveobs(result.d);
	                    BindObsGrid();
	                    jQuery("#<%=ddlObservation.ClientID %>").append(jQuery("<option></option>").val(result).html(jQuery("#<%=txtObservation.ClientID %>").val()));
                        modelAlert('Observation Saved Successfully');
                    }
                },
	            error: function (xhr, status) {
	                modelAlert('Error occurred, Please contact administrator');
	                //  jQuery("#<%=lblMsg.ClientID %>").text('Error occurred, Please contact administrator');
                }
	        });
	    }
	    function BindObsGrid() {
	        jQuery("#<%=lblMsg.ClientID %>").text('');
	        jQuery.ajax({
	            url: "../Lab/Services/MapInvestigationObservation.asmx/GetObservationData",
	            data: '{ InvestigationID: "' + jQuery("#<%=ddlInvestigation.ClientID %>").val() + '"}', // parameter map
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    async: false,
                    success: function (result) {
                        obsData = jQuery.parseJSON(result.d);
                        var output = jQuery('#tb_InvestigationItems').parseTemplate(obsData);
                        jQuery('#div_InvestigationItems').html(output);
                        jQuery("#tb_grdLabSearch").tableDnD({
                            onDragClass: "GridViewDragItemStyle",
                            onDragStart: function (table, row) {
                            }
                        });
                        tablefunctioning();
                        unbindimgeditclick(0);
                        if (jQuery("#tb_grdLabSearch  tr").length == "1") {
                            jQuery("#btnSave").attr('disabled', true);
                            jQuery("#div_InvestigationItems").hide();
                        }
                        else {
                            jQuery("#btnSave").removeAttr('disabled');
                            jQuery("#div_InvestigationItems").show();
                        }
                    },
                    error: function (xhr, status) {
                        modelAlert('Error occurred, Please contact administrator');
                       // jQuery("#<%=lblMsg.ClientID %>").text('Error occurred, Please contact administrator');
                    }
                });

                }
                function BindSampleType() {
                    jQuery("#<%=ddlSample.ClientID %> option").remove();
                    jQuery.ajax({
                        url: "../Lab/Services/MapInvestigationObservation.asmx/SampleType",
                        data: '{ }',
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        timeout: 120000,
                        dataType: "json",
                        success: function (result) {
                            var SampleType = jQuery.parseJSON(result.d);
                            jQuery("#<%=ddlSample.ClientID %>").append(jQuery("<option></option>").val("0").html("Select"));
                        for (i = 0; i < SampleType.length; i++) {
                            jQuery("#<%=ddlSample.ClientID %>").append(jQuery("<option></option>").val(SampleType[i].ID).html(SampleType[i].SampleType));
                        }
                        jQuery("#<%=ddlSample.ClientID %>").chosen();
                        jQuery('#ddlSample_chosen').css('width', '189px');
                    },
                    error: function (xhr, status) {
                        jQuery("#<%=ddlSample.ClientID %>").attr("disabled", false);
                        modelAlert('Error occurred, Please contact administrator');
                      //  jQuery("#<%=lblMsg.ClientID %>").text('Error occurred, Please contact administrator');
                    }
                });
            }
	</script>
	<script type="text/javascript">
	    function ClearControl() {
	        jQuery("#chkNewInv").attr('checked', false);
	        clearform2();
	        showType();
	        if (jQuery("#tb_grdLabSearch  tr").length == "0") {
	            jQuery("#btnSave").attr('disabled', true);
	            jQuery("#div_InvestigationItems").hide();
	        }
	        else {
	            jQuery("#btnSave").removeAttr('disabled');
	            jQuery("#div_InvestigationItems").show();
	        }
	        jQuery("#<%=lblMsg.ClientID %>").text('');
        }
        function clearform2() {
            jQuery(':text, textarea').val('');
            jQuery('select:not(select[id$=ddlUserName],select[id$=ddlDepartment]) option:nth-child(1)').attr('selected', 'selected').attr("disabled", false);
            jQuery(".chk").find(':checkbox').attr('checked', '');
            jQuery("#tb_grdLabSearch tr").remove();
            jQuery("#<%=ddlType.ClientID%>").attr("disabled", false);
            jQuery("#<%=ddlSample.ClientID%>").attr("disabled", false);
            jQuery("#<%=lstInvestigation.ClientID%>").prop("selectedIndex", -1).attr("disabled", false);
            jQuery("#<%=ddlDepartment.ClientID %>").attr('disabled', false);
            jQuery("#<%=cmbDept.ClientID %>").attr('disabled', false);

            jQuery("#<%=txtInv.ClientID %>").attr('disabled', true);
            jQuery("#chkOutsource").attr('checked', false);
            jQuery("#chkOutsource,#ChkIsUrgent,#chkPrintSeparate,#chkPrintSampleName").attr('checked', false);
            jQuery("#chkShowPtRpt,#chkShowOnlineRpt,#chkIsCulture").attr('checked', true);
        }
	</script>
	 <script type="text/javascript">
	     function unbindimgeditclick(isHeader) {
	         jQuery("#tb_grdLabSearch tr").each(function () {
	             var ischecked = jQuery(this).find("#chkHeader").is(":checked");
	             var edit = jQuery(this).find("#imgEdit");
	             var Critical = jQuery(this).find("#chkCritical");
	             var Method = jQuery(this).find("#txtMethod");
	             var Prefix = jQuery(this).find("#txtPrefix");
	             var Comment = jQuery(this).find("#chkComment");
	             var ParentID = jQuery(this).find("#txtParentid");
	             // var Microscopy = jQuery(this).find("#chkMicroscopy");
	             if (ischecked) {
	                 jQuery(Prefix).attr("disabled", "disabled").val('');
	                 jQuery(Method).attr("disabled", "disabled").val('');
	                 jQuery(Critical).attr("disabled", "disabled").attr('checked', false);
	                 // jQuery(Microscopy).attr("disabled", "disabled").attr('checked', false);;
	                 jQuery(ParentID).attr("disabled", "disabled").val('');
	                 jQuery(Comment).attr("disabled", "disabled").attr('checked', false);;
	                 jQuery(edit).hide();
	             }
	             else {
	                 if (isHeader == 1) {
	                     jQuery(Prefix).removeAttr("disabled").val('');
	                     jQuery(Method).removeAttr("disabled").val('');
	                     jQuery(Critical).removeAttr("disabled").attr('checked', false);
	                     //jQuery(Microscopy).removeAttr("disabled").attr('checked', false);
	                     jQuery(ParentID).removeAttr("disabled").val('');
	                     jQuery(Comment).removeAttr("disabled").attr('checked', false);
	                     jQuery(edit).show();
	                 }
	                 if (isHeader == 0) {
	                     jQuery(Prefix).removeAttr("disabled");
	                     jQuery(Method).removeAttr("disabled");
	                     jQuery(Critical).removeAttr("disabled").attr('checked', false);
	                     //jQuery(Microscopy).removeAttr("disabled").attr('checked', false);
	                     jQuery(ParentID).removeAttr("disabled");
	                     jQuery(Comment).removeAttr("disabled").attr('checked', false);
	                     jQuery(edit).show();
	                 }
	             }
	         });
	     }
	     function tablefunctioning() {
	         jQuery("#tb_grdLabSearch tr").find("#chkHeader").filter(':checked').each(function () {
	             jQuery(this).closest("tr").addClass('GridViewChkHeaderStyle');
	         });

	         jQuery("#tb_grdLabSearch").find("#imgRmv").click(function () {
	             if (confirm("Do You Want to Remove Observation") == false) {
	                 return false;
	             }
	             RemoveObs(jQuery(this).closest("tr").attr("id"));
	         });
	         jQuery("#tb_grdLabSearch").find("#imgEdit").click(function () {
	             openpopup(jQuery(this).closest("tr").attr("id"), jQuery(this).closest("tr").find('td:eq(' + 1 + ')').html());
	         });
	         jQuery("#tb_grdLabSearch").find("#chkHeader").click(function () {
	             var stst = MakeHeader(jQuery(this).closest("tr").attr("id"))
	             if (stst) {
	                 unbindimgeditclick(1);
	             }

	         });
	         jQuery("#tb_grdLabSearch").find("#chkCritical").click(function () {
	             SetCritical(jQuery(this).closest("tr").attr("id"))
	         });
	         $("#tb_grdLabSearch").find("#chkcomment").click(function () {
	             SetComment();
	         });
	     }
	     function AddObs() {
	         jQuery("#<%=lblMsg.ClientID %>").text('');
	         var DuplicateObs = '0';
	         if (jQuery("#<%=ddlInvestigation.ClientID %>").val() == "") {
	             DuplicateObs = '1';
	             modelAlert('Please Select Investigation');
	             //  jQuery("#<%=lblMsg.ClientID %>").text('Please Select Investigation');
	             return;
	         }
             if (jQuery("#<%=ddlObservation.ClientID %>").val() == "") {
	             DuplicateObs = '1';
	             modelAlert('Please Select Observation');
	             // jQuery("#<%=lblMsg.ClientID %>").text('Please Select Observation');
                 return;
             }
             jQuery("#tb_grdLabSearch tr").each(function () {
                 if (jQuery(this).closest("tr").attr("id") == jQuery("#<%=ddlObservation.ClientID %>").val()) {
                     DuplicateObs = '1';
                     modelAlert('Observation Already Added');
                     // jQuery("#<%=lblMsg.ClientID %>").text('Observation Already Added')
                     return;
                 }
             });
             if (DuplicateObs != '1') {
                 saveobs(jQuery("#<%=ddlObservation.ClientID %>").val());
                 BindObsGrid();
             }
         }
         function addnewrow(ObsId, ObsName) {
             var count = jQuery("#tb_grdLabSearch tr").length;
             var newRow = jQuery('<tr />').attr('id', ObsId);
             newRow.html('<td class="GridViewLabItemStyle" onmouseover="chngcurmove()">' + count + '</td> ' +
                 '<td class="GridViewLabItemStyle" onmouseover="chngcurmove()">' + ObsID + '</td> ' +
                 '<td class="GridViewLabItemStyle" onmouseover="chngcurmove()">' + ObsName + '</td> ' +
                 '<td class="GridViewLabItemStyle" onmouseover="chngcurmove()"><input id="txtPrefix" type="text"  /></td> ' +
                 '<td  class="GridViewLabItemStyle" ></td> ' +
                 '<td class="GridViewLabItemStyle" onmouseover="chngcurmove()"><input id="txtMethod" type="text"  /></td> ' +
                 '<td class="GridViewLabItemStyle"><input id="chkHeader" type="checkbox" onmouseover="chngcur()"/></td> ' +
                 '<td class="GridViewLabItemStyle"><input id="chkCritical" type="checkbox" onmouseover="chngcur()" /></td> ' +
                 '<td class="GridViewLabItemStyle"><input id="chkMicroscopy" type="checkbox" onmouseover="chngcur()" /></td> ' +
                 '<td class="GridViewLabItemStyle"><input id="txtParentid" type="text" onmouseover="chngcur()" /></td> ' +
                 '<td class="GridViewLabItemStyle"><img id="imgEdit" src="~/Images/edit.png" onmouseover="chngcur()" /></td> ' +
                 '<td class="GridViewLabItemStyle"><img id="imgRmv" src="/Images/Delete.gif" onmouseover="chngcur()" /></td>');
             jQuery("#tb_grdLabSearch").append(newRow);
             jQuery("#tb_grdLabSearch").tableDnD({
                 onDragClass: "GridViewDragItemStyle",
                 onDragStart: function (table, row) {
                 }
             });
             tablefunctioning();
         }
         function chngcur() {
             document.body.style.cursor = 'pointer';
         }
         function chngcurmove() {
             document.body.style.cursor = 'move';
         }
         function SetCritical(ObsId) {
             if (jQuery("#tb_grdLabSearch").find('#' + ObsId).find("#chkCritical").attr('checked')) {
                 if (confirm("Do You Want to set Critical Level for this Observation?") == true) {
                     jQuery("#" + ObsId).removeClass('GridViewChkHeaderStyle');
                     jQuery("#" + ObsId).find("#chkCritical").attr('checked', '');
                 }
                 else {
                     jQuery("#tb_grdLabSearch").find("#" + ObsId).find("#chkCritical").attr('checked', '');
                     return false;
                 }
             }
             else {
                 if (confirm("Do You Want to Remove Critical Level for this Observation?") == true)
                     jQuery("#" + ObsId).removeClass('GridViewChkHeaderStyle');
                 else {
                     jQuery("#tb_grdLabSearch").find('#' + ObsId).find("#chkCritical").attr('checked', 'checked');
                     return false;
                 }
             }
         }
         function MakeHeader(ObsId) {
             if (jQuery("#tb_grdLabSearch").find('#' + ObsId).find("#chkHeader").attr('checked')) {
                 if (confirm("Do You Want to this Observation Make Header?") == true) {
                     jQuery("#" + ObsId).find("#chkHeader").attr('checked', 'checked');
                     jQuery("#" + ObsId).addClass('GridViewChkHeaderStyle');
                     return true;
                 }
                 else {
                     jQuery("#tb_grdLabSearch").find('#' + ObsId).find("#chkHeader").attr('checked', false);
                     return false;
                 }
             }
             else {
                 if (confirm("Do You Want to Remove Header") == true) {
                     jQuery("#" + ObsId).removeClass('GridViewChkHeaderStyle');
                     return true;
                 }
                 else {
                     jQuery("#tb_grdLabSearch").find('#' + ObsId).find("#chkHeader").attr('checked', 'checked');
                     return false;
                 }
             }
         }
	</script>
	 <script type="text/javascript" >
	     var values = [];
	     jQuery(document).ready(function () {
	         var options = jQuery('#<% = ddlInvestigation.ClientID %> option');
	         jQuery.each(options, function (index, item) {
	             values.push(item.innerHTML);
	         });
	         jQuery('#<%=txtSearch.ClientID %>').bind("keyup keydown", function (e) {
	             var key = (e.keyCode ? e.keyCode : e.charCode);
	             if (key != 9) {
	                 var filter = jQuery(this).val();
	                 if (filter == '') {
	                     jQuery('#<% = ddlInvestigation.ClientID %> option:nth-child(1)').attr('selected', 'selected');
	                     BindObsGrid();
	                     return;
	                 }
                     DoListBoxFilter1('#<% = ddlInvestigation.ClientID %>', '#<% = txtSearch.ClientID %>', '0', filter, values);
	             }
	         });

	     });
         function DoListBoxFilter1(listBoxSelector, textbox, searchtype, filter, values) {
             var list = jQuery(listBoxSelector);
             if (searchtype == "0") {
                 for (i = 0; i < values.length; ++i) {
                     var value = '';
                     if (values[i].indexOf('#') == -1)
                         continue;
                     else
                         value = values[i].split('#')[0].trim();
                     var len = jQuery(textbox).val().length;
                     if (value.substring(0, len).toLowerCase() == (filter.toLowerCase())) {
                         jQuery('#<% = ddlInvestigation.ClientID %> option:nth-child(' + (i + 1) + ')').attr('selected', i);
                         BindObsGrid();
                         return;
                     }
                 }
             }

         }
         function AddInvestigation(sender, evt) {
             if (evt.keyCode > 0) {
                 keyCode = evt.keyCode;
             }
             else if (typeof (evt.charCode) != "undefined") {
                 keyCode = evt.charCode;
             }
             if (keyCode == 13) {
                 BindObsGrid();
             }
         }
	</script>
	<script type="text/javascript">
	    function loadDetail(str) {
	        if (str != "0") {
	            // BindSampleType();

	            var val = str.split('$');
	            jQuery("#<%=txtInv.ClientID %>").removeAttr('disabled');
	            jQuery("#ddlGroupHead").chosen('destroy')
	            document.getElementById('<%=ddlGroupHead.ClientID %>').value = val[0];
	            jQuery('#ddlGroupHead').chosen().css('width', '189px');
	            document.getElementById('<%=txtInv.ClientID %>').value = val[2];
	            document.getElementById('<%=ddlType.ClientID %>').value = val[3];
	            document.getElementById('<%=ddlReportType.ClientID %>').value = val[4];
	            document.getElementById('<%=txtPrintSequence.ClientID %>').value = val[5];
	            //  document.getElementById('chkNewInv').checked=false;

	            document.getElementById('<%=txtInvestigation_ID.ClientID %>').value = val[6];
	            document.getElementById('<%=txtInvestigation_ObservationType_ID.ClientID %>').value = val[7];
	            document.getElementById('<%=txtItemID.ClientID %>').value = val[8];
	            document.getElementById('<%=txtDescription.ClientID %>').value = val[9];
	            document.getElementById('<%=txtPrinciple.ClientID %>').value = val[10];
	            document.getElementById('<%=ddlGender.ClientID %>').value = val[14];

	            document.getElementById('<%=txtCptcode.ClientID %>').value = val[16];
	            //for active/deactive
	            if (val[17] == 1) {
	                jQuery('#chkActive').attr('checked', 'checked');
	            } else {
	                jQuery('#chkActive').removeAttr('checked');
	            }
	            //for IsOutSource
	            if (val[18] == 1)
	                jQuery('#chkOutsource').attr('checked', 'checked');
	            else
	                jQuery('#chkOutsource').removeAttr('checked');

	            if (val[19] == 1)
	                jQuery("#rdoRateYes").attr('checked', 'checked');
	            else
	                jQuery('#rdoRateNo').attr('checked', 'checked');


	            if (val[20] == 1)
	                jQuery("#ChkIsUrgent").attr('checked', 'checked');
	            else
	                jQuery('#ChkIsUrgent').removeAttr('checked');

	            if (val[21] == 1)
	                jQuery("#chkShowPtRpt").attr('checked', 'checked');
	            else
	                jQuery('#chkShowPtRpt').removeAttr('checked');

	            if (val[22] == 1)
	                jQuery("#chkShowOnlineRpt").attr('checked', 'checked');
	            else
	                jQuery('#chkShowOnlineRpt').removeAttr('checked');

	            if (val[23] == 1)
	                jQuery("#chkPrintSeparate").attr('checked', 'checked');
	            else
	                jQuery('#chkPrintSeparate').removeAttr('checked');

	            if (val[24] == 1)
	                jQuery("#chkPrintSampleName").attr('checked', 'checked');
	            else
	                jQuery('#chkPrintSampleName').removeAttr('checked');
	            debugger;
	            jQuery("#cmbDept").chosen('destroy').css('width', '189px');
	            if (val[27] != 0) {
	                jQuery('#cmbDept').val(val[27]);
	            }
	            else {
	                jQuery('#cmbDept').val(0);
	            }
	            jQuery("#cmbDept").chosen().css('width', '189px');
	            if (val[26] == 1)
	                jQuery("#rdoIsDisYes").attr('checked', 'checked');
	            else
	                jQuery('#rdoIsDisNo').attr('checked', 'checked');

	            if (val[28] == 1)
	                jQuery("#chkIsCulture").attr('checked', 'checked');
	            else
	                jQuery('#chkIsCulture').removeAttr('checked');
	            hide();
	            showType();
	            debugger;
	            jQuery("#ddlSample").chosen('destroy').css('width', '189px');
	            if (val[15] != 0) {
	                jQuery("#ddlSample").val(val[15]);
	            }
	            else {
	                jQuery("#ddlSample").val(0);
	            }

	            if (val[29] != 0) {
	                $("#<%=ddlSampleContainer.ClientID%>").val(val[29]);
	            }
	            else {
	                $("#<%=ddlSampleContainer.ClientID%>").val(1);
	            }
                jQuery("#ddlSample").chosen().css('width', '189px');
            }
        }
	    function SaveInvestigation() {
	        jQuery('#pnlSave').show();
            if (jQuery("#chkNewInv").attr('checked')) {
                SaveNewInvestigation();
            }
            else {
                UpdateInvestigation();
            }
        }
        function SaveNewInvestigation() {
            jQuery('#pnlSave').show();
            //jQuery(':text').attr('disabled', true);
            if (jQuery("#<%=txtInv.ClientID %>").val() == "") {
                modelAlert('Investigation Name cannot be Blank');
                //jQuery(':text').attr('disabled', false); 
                $('#pnlSave').attr('disabled', false);
                return;
            }
            if ((jQuery("#<%=ddlType.ClientID%>").val() == "R") && (jQuery("#<%=ddlSample.ClientID%>").val() == "0") && (jQuery("#<%=ddlReportType.ClientID%>").val() != 5)) {
                modelAlert('Please Select Sample Type');
                return;
            }
            if ((jQuery("#<%=cmbDept.ClientID%>").val() == "0")) {
                modelAlert('Please Select Department');
                return;
            }

            var outsource = 0;
            if (jQuery("#chkOutsource").is(':checked')) {
                outsource = 1;
            }
            var IsUrgent = jQuery('#ChkIsUrgent').is(':checked') ? 1 : 0;
            var ShowPtRpt = jQuery('#chkShowPtRpt').is(':checked') ? 1 : 0;
            var ShowOnlineRpt = jQuery('#chkShowOnlineRpt').is(':checked') ? 1 : 0;
            var PrintSeperate = jQuery('#chkPrintSeparate').is(':checked') ? 1 : 0;
            var PrintSampleName = jQuery('#chkPrintSampleName').is(':checked') ? 1 : 0;
            jQuery('#pnlSave').show();
            //ddlSampleContainer
            var searchparameter = {
                InvName: jQuery("#<%=txtInv.ClientID %>").val(),
                Description: jQuery("#<%=txtDescription.ClientID %>").val(),
                DepartmentID: jQuery("#<%=ddlGroupHead.ClientID %>").val(),
                DepartmentName: jQuery("#<%=ddlGroupHead.ClientID %> :selected").text(),
                ReportType: jQuery("#<%=ddlReportType.ClientID %>").val(),
                SampleType: jQuery("#<%=ddlType.ClientID %>").val(),
                PrintSequence: jQuery("#<%=txtPrintSequence.ClientID %>").val(),
                Gender: jQuery("#<%=ddlGender.ClientID %>").val(),
                Principle: jQuery("#<%=txtPrinciple.ClientID %>").val(),
                sampletypename: jQuery("#<%=ddlSample.ClientID %> :selected").text(),
                CPTCode: jQuery("#<%=txtCptcode.ClientID %>").val(),
                outsource: outsource,
                RateEditable: jQuery('input[name=rdoRate]:checked').val(),
                IsUrgent: IsUrgent,
                ShowPtRpt: ShowPtRpt,
                ShowOnlineRpt: ShowOnlineRpt,
                PrintSeperate: PrintSeperate,
                PrintSampleName: PrintSampleName,
                DeptID: jQuery("#<%=cmbDept.ClientID%>").val(),
                IsDiscountable: jQuery('input[name=rdoIsDis]:checked').val(),
                SampleTypeID: jQuery("#<%=ddlSample.ClientID %>").val(),
		        IsCulture: jQuery('#chkIsCulture').is(':checked') ? 1 : 0,
		        SampleContainer: jQuery("#<%=ddlSampleContainer.ClientID %>").val()
            }
            jQuery.ajax({
                url: "../Lab/Services/MapInvestigationObservation.asmx/SaveNewInvestigation",
                data: JSON.stringify(searchparameter),
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    RateData = result.d;  
                   // var newvalue = RateData.split('|')[0];
                    // if (RateData.split('|')[1] == "1") {
                    if (RateData == "1") {
                        //  jQuery("#<%=lblMsg.ClientID %>").text('Record Saved Successfully');
                        modelAlert('Record Saved Successfully');
                        jQuery("#<%=ddlInvestigation.ClientID %>").append(jQuery("<option></option>").val(newvalue.split('$')[6]).html(jQuery("#<%=txtInv.ClientID %>").val()));
                        jQuery("#<%=lstInvestigation.ClientID %>").prepend(jQuery("<option></option>").val(newvalue).html(jQuery("#<%=txtInv.ClientID %>").val()));
                        clearform();
                        jQuery('#pnlSave').show();
                        jQuery('#pnlSave').attr('disabled', false);
                        //jQuery(':text').attr('disabled', false);
                       // BindListBox();
                        jQuery("#<%=lstInvestigation.ClientID%>").attr('disabled', true);
                    }
                    else if (RateData == "0") {
                        modelAlert('Investigation Already Exist');
                        // jQuery("#<%=lblMsg.ClientID %>").text('Investigation Already Exist');
                        jQuery('#pnlSave').show();
                    }
                    else {
                        modelAlert('Record Not Saved');
                        //  jQuery("#<%=lblMsg.ClientID %>").text('Record Not Saved');
                        jQuery('#pnlSave').show();
                    }
                    jQuery('#pnlSave').attr('disabled', false);

                    //jQuery(':text').attr('disabled', false);
                },
                error: function (xhr, status) {
                    modelAlert('Error occurred, Please contact administrator');
                    //jQuery("#<%=lblMsg.ClientID %>").text('Error occurred, Please contact administrator');
                    jQuery('#pnlSave').attr('disabled', false);
                }
            });
        }
	    function UpdateInvestigation() { 
            if (jQuery("#<%=txtInv.ClientID %>").val() == "") {
                modelAlert('Please Select Investigation To Be Updated');
                //    alert('Please Select Investigation To Be Updated');
                return;
            }
            var LoginType = '<%= Session["LoginType"].ToString() %>';
            if ((jQuery("#<%=ddlReportType.ClientID%>").val() != 5)) {
                if ((jQuery("#<%=ddlType.ClientID%>").val() == "R") && (jQuery("#<%=ddlSample.ClientID%>").val() == "0")) {
                    modelAlert('Please Select Sample Type');
                    // alert('Please Select Sample Type');
                    return;
                }
            }
            if ((jQuery("#<%=cmbDept.ClientID%>").val() == "0")) {
                //  alert('Please Select Department');
                modelAlert('Please Select Department');
                return;
            }

            var active = jQuery("#chkActive").is(':checked') ? 1 : 0;

            var outsource = jQuery("#chkOutsource").is(':checked') ? 1 : 0;


            var IsUrgent = jQuery('#ChkIsUrgent').is(':checked') ? 1 : 0;
            var ShowPtRpt = jQuery('#chkShowPtRpt').is(':checked') ? 1 : 0;
            var ShowOnlineRpt = jQuery('#chkShowOnlineRpt').is(':checked') ? 1 : 0;
            var PrintSeperate = jQuery('#chkPrintSeparate').is(':checked') ? 1 : 0;
            var PrintSampleName = jQuery('#chkPrintSampleName').is(':checked') ? 1 : 0;
            var searchparameter = {
                InvName: jQuery("#<%=txtInv.ClientID %>").val(),
                Description: jQuery("#<%=txtDescription.ClientID %>").val(),
                InvID: jQuery("#<%=txtInvestigation_ID.ClientID %>").val(),
                ItemID: jQuery("#<%=txtItemID.ClientID %>").val(),
                DepartmentID: jQuery("#<%=ddlGroupHead.ClientID %>").val(),
                InvObsId: jQuery("#<%=txtInvestigation_ObservationType_ID.ClientID %>").val(),
                DepartmentName: jQuery("#<%=ddlGroupHead.ClientID %> :selected").text(),
                ReportType: jQuery("#<%=ddlReportType.ClientID %>").val(),
                SampleType: jQuery("#<%=ddlType.ClientID %>").val(),
                PrintSequence: jQuery("#<%=txtPrintSequence.ClientID %>").val(),
                Gender: jQuery("#<%=ddlGender.ClientID %>").val(),
                Principle: jQuery("#<%=txtPrinciple.ClientID %>").val(),
                sampletypename: jQuery("#<%=ddlSample.ClientID %> :selected").text(),
                CPTCode: jQuery("#<%=txtCptcode.ClientID %>").val(),
                Active: active,
                outsource: outsource,
                RateEditable: jQuery('input[name=rdoRate]:checked').val(),
                IsUrgent: IsUrgent,
                ShowPtRpt: ShowPtRpt,
                ShowOnlineRpt: ShowOnlineRpt,
                PrintSeperate: PrintSeperate,
                PrintSampleName: PrintSampleName,
                DeptID: jQuery("#<%=cmbDept.ClientID%>").val(),
                IsDiscountable: jQuery('input[name=rdoIsDis]:checked').val(),
                SampleTypeID: jQuery("#<%=ddlSample.ClientID %>").val(),
		        IsCulture: jQuery('#chkIsCulture').is(':checked') ? 1 : 0,
		        SampleContainer: jQuery("#<%=ddlSampleContainer.ClientID %>").val()
            }
            jQuery.ajax({
                url: "../Lab/Services/MapInvestigationObservation.asmx/UpdateInvestigation",
                data: JSON.stringify(searchparameter),
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    if (result.d == "1") {
                        // jQuery("#<%=lblMsg.ClientID %>").text('Record Updated Successfully');
                        modelAlert('Record Updated Successfully');
                        clearform();
                      //  BindInvestigation();
                    }
                    else {
                        modelAlert('Record Not Updated');
                        //  jQuery("#<%=lblMsg.ClientID %>").text('Record Not Updated');
                    }
                    hideDiv();
                },
                error: function (xhr, status) {
                    modelAlert('Error occurred, Please contact administrator');
                    // jQuery("#<%=lblMsg.ClientID %>").text('Error occurred, Please contact administrator');
                }
            });
        }

	    function BindInvestigation() {
	        jQuery('form').attr('disabled', true);
	        jQuery("#<%=ddlInvestigation.ClientID %> option").remove();

	        jQuery.ajax({
	            url: "../Lab/Services/MapInvestigationObservation.asmx/BindInvestigation",
	            data: '{ }',
	            type: "POST",
	            contentType: "application/json; charset=utf-8",
	            timeout: 120000,
	            dataType: "json",
	            success: function (result) {
	                bindInv = jQuery.parseJSON(result.d);
	                if (bindInv.length == 0) {
	                    jQuery("#<%=ddlInvestigation.ClientID %>").append(jQuery("<option></option>").val("").html("---No Data Found---"));
                        }
                        else {
                            jQuery("#<%=ddlInvestigation.ClientID %>").append(jQuery("<option></option>").val('').html('----Select Investigation----'));
                            for (i = 0; i < bindInv.length; i++) {
                                jQuery("#<%=ddlInvestigation.ClientID %>").append(jQuery("<option></option>").val(bindInv[i].Investigation_id).html(bindInv[i].Name));
                            }
                        }
                        BindListBox();
                        jQuery('form').attr('disabled', false);
                    },
                    error: function (xhr, status) {
                        jQuery('form').attr('disabled', false);
                    }
                });
            }
            function BindListBox() {
                jQuery('form').attr('disabled', true);
                jQuery("#<%=lstInvestigation.ClientID %> option").remove();

                jQuery("#<%=lstInvestigation.ClientID %>").attr("disabled", true);

                jQuery.ajax({
                    url: "../Lab/Services/MapInvestigationObservation.asmx/BindListBox",
                    data: '{ Dept:"' + jQuery("#<%=ddlDepartment.ClientID %>").val() + '"}',
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        bindList = jQuery.parseJSON(result.d);
                        if (bindList.length == 0) {
                            jQuery("#<%=lstInvestigation.ClientID %>").append(jQuery("<option></option>").val("0").html("---No Data Found---"));
                    }
                    else {
                        for (i = 0; i < bindList.length; i++) {
                            jQuery("#<%=lstInvestigation.ClientID %>").append(jQuery("<option></option>").val(bindList[i].newValue).html(bindList[i].NAME));
		                }
                    }
                    jQuery("#<%=lstInvestigation.ClientID %>").attr("disabled", false);
                    jQuery('form').attr('disabled', false);
                },
                    error: function (xhr, status) {
                      //  alert("Error ");
                        modelAlert('Error');
                        lstInvestigation.attr("disabled", false);
                        jQuery('form').attr('disabled', false);
                    }
                });
        }
	</script>
	 <script type="text/javascript">
	     function openpopup(ObsId, ObsName) {

	         BindMachine();
	         $(':text').bind('keyup blur', function () {
	             if (this.value != '' && this.value.match(/[\"|\']/g)) {
	                 this.value = this.value.replace(/[\"|\']/g, '');
	             }
	         });
	         var maxLength = 10;
	         $("#txtToAge").keyup(function () {
	             var text = $(this).val();
	             var textLength = text.length;
	             if (textLength > maxLength) {
	                 $(this).val(text.substring(0, (maxLength)));
	             }
	         });

	         var InvId = jQuery("#<%=ddlInvestigation.ClientID %>").val();
	         ObsIdStore = ObsId;
	         InvIdStore = InvId;
	         SelectGen(InvIdStore, ObsIdStore);
	         GetObsMasterData(ObsIdStore);
	         $('#<%=rblGender_popup.ClientID%> input').click(function () {
	             GetObservationDetails(InvIdStore, ObsIdStore);
            });
            $('#<%=ddlMachine_popup.ClientID%>').change(function () {
                GetObservationDetails(InvIdStore, ObsIdStore);
	         });
	         $('#<%=ddlCentre_popup.ClientID%>').change(function () {
	             GetObservationDetails(InvIdStore, ObsIdStore);
	         });
	       //  href = '../Lab/EditObservationDetail.aspx?ObsId=' + ObsId + '&InvId=' + jQuery("#<%=ddlInvestigation.ClientID %>").val() + '&ObsName=' + ObsName;
	         //  showuploadbox(href);

	         $('#EditObservation').show();
	     }
	     function showuploadbox(href) {
	         $.fancybox({
	             maxWidth: 1150,
	             maxHeight: 1000,
	             fitToView: true,
	             width: '94%',
	             href: href,
	             height: '90%',
	             autoSize: false,
	             closeClick: false,
	             openEffect: 'none',
	             closeEffect: 'none', 
	             'type': 'iframe'
	         });
	     }
	     function AddNewObs() {
	         jQuery("#<%=txtObservation.ClientID%>").val('');
	         jQuery("#<%=txtObsSuffix.ClientID%>").val('');
	         if (jQuery("#<%=ddlInvestigation.ClientID %>").val() == "") {
	             modelAlert('Please Select an Investigation');
	             //  jQuery("#<%=lblMsg.ClientID %>").text('Please Select an Investigation');
	             return;
	         }
             $('#divpnlNewObs').show();
         }
         function clearform() {
             jQuery(':text, textarea').val('');
             jQuery('select:not(select[id$=ddlUserName]) option:nth-child(1)').attr('selected', 'selected');
             jQuery(".chk").find(':checkbox').attr('checked', '');
             jQuery("#tb_grdLabSearch tr").remove();
             jQuery("#chkOutsource,#ChkIsUrgent,#chkPrintSeparate,#chkPrintSampleName").attr('checked', false);
             jQuery("#chkShowPtRpt,#chkShowOnlineRpt,#chkIsCulture").attr('checked', true);
         }
         function clearform3() {
             jQuery(':text, textarea').val('');
             jQuery('select:not(select[id$=ddlUserName],select[id$=ddlDepartment]) option:nth-child(1)').attr('selected', 'selected');
             jQuery(".chk").find(':checkbox').attr('checked', '');
             jQuery("#tb_grdLabSearch tr").remove();
             jQuery("#<%=ddlType.ClientID%>").attr("disabled", false);
             jQuery("#<%=ddlSample.ClientID%>").attr("disabled", true);
             jQuery("#<%=lstInvestigation.ClientID%>").prop("selectedIndex", -1);

             jQuery("#chkOutsource,#ChkIsUrgent,#chkPrintSeparate,#chkPrintSampleName").attr('checked', false);
             jQuery("#chkShowPtRpt,#chkShowOnlineRpt,#chkIsCulture").attr('checked', true);
         }

	</script>
	<script type="text/javascript">
	    function hideDiv() {
	        if (jQuery("#tb_grdLabSearch  tr").length == "0") {
	            jQuery("#btnSave").attr('disabled', true);
	            jQuery("#div_InvestigationItems").hide();
	        }
	        else {
	            jQuery("#btnSave").removeAttr('disabled');
	            jQuery("#div_InvestigationItems").show();
	        }
	    }
	    function validatespace() {
	        if (jQuery('#<%=txtDescription.ClientID %>').val().charAt(0) == ' ' || jQuery('#<%=txtDescription.ClientID %>').val().charAt(0) == '.' || jQuery('#<%=txtDescription.ClientID %>').val().charAt(0) == ',') {
	            jQuery('#<%=txtDescription.ClientID %>').val('');
	            modelAlert('First Character Cannot Be Space/Dot');
	            // alert('First Character Cannot Be Space/Dot');
	            jQuery('#<%=txtDescription.ClientID %>').val().replace(jQuery('#<%=txtDescription.ClientID %>').val().charAt(0), "");
	            return false;
            }
            if (jQuery('#<%=txtPrinciple.ClientID %>').val().charAt(0) == ' ' || jQuery('#<%=txtPrinciple.ClientID %>').val().charAt(0) == '.' || jQuery('#<%=txtPrinciple.ClientID %>').val().charAt(0) == ',') {
	            jQuery('#<%=txtPrinciple.ClientID %>').val('');
                modelAlert('First Character Cannot Be Space/Dot');
                //   alert('First Character Cannot Be Space/Dot');
                jQuery('#<%=txtPrinciple.ClientID %>').val().replace(jQuery('#<%=txtPrinciple.ClientID %>').val().charAt(0), "");
                return false;
            }
            if (jQuery('#<%=txtInv.ClientID %>').val().charAt(0) == ' ' || jQuery('#<%=txtInv.ClientID %>').val().charAt(0) == '.' || jQuery('#<%=txtInv.ClientID %>').val().charAt(0) == ',') {
	            jQuery('#<%=txtInv.ClientID %>').val('');
                modelAlert('First Character Cannot Be Space/Dot');
                // alert('First Character Cannot Be Space/Dot');
                jQuery('#<%=txtInv.ClientID %>').val().replace(jQuery('#<%=txtInv.ClientID %>').val().charAt(0), "");
                return false;
            }
            else {
                return true;
            }

        }
        function check(e) {
            var keynum
            var keychar
            var numcheck
            if (window.event) {
                keynum = e.keyCode
            }
            else if (e.which) {
                keynum = e.which
            }
            keychar = String.fromCharCode(keynum)

            if (jQuery('#<%=txtDescription.ClientID %>').val().charAt(0) == ' ') {
                jQuery('#<%=txtDescription.ClientID %>').val('');
                return false;
            }
            if (jQuery('#<%=txtPrinciple.ClientID %>').val().charAt(0) == ' ') {
                jQuery('#<%=txtPrinciple.ClientID %>').val('');
                return false;
            }
            if (jQuery('#<%=txtInv.ClientID %>').val().charAt(0) == ' ') {
                jQuery('#<%=txtInv.ClientID %>').val('');
                return false;
            }
            //List of special characters you want to restrict
            if (keychar == "'" || keychar == "`" || keychar == "!" || keychar == "," || keychar == "~" || keychar == ";" || (keynum >= "40" && keynum <= "44") || (keynum >= "91" && keynum <= "95") || (keynum >= "58" && keynum <= "64") || (keynum >= "34" && keynum <= "38") || (keynum >= "123" && keynum <= "125")) {
                return false;
            }
            else {
                return true;
            }
        }
	</script>
	<script type="text/javascript">
	    function saveMapping() {
	        var ObsOrder = "";
	        jQuery("#<%=lblMsg.ClientID %>").text('');
	        if (jQuery("#tb_grdLabSearch tr").length == 0) {
	            modelAlert('Please Map Observation');
	            //  jQuery("#<%=lblMsg.ClientID %>").text('Please Map Observation');
	            return;
	        }
            jQuery('input,select').attr('disabled', true);
            jQuery("#tb_grdLabSearch tr").each(function () {
                if (jQuery(this).closest("tr").attr("id") != "obsHeader") {
                    ObsOrder += jQuery(this).closest("tr").attr("id") + '|' + jQuery(this).find('#txtPrefix').val() + '|' + jQuery(this).find('#txtMethod').val() + '|';

                    if (jQuery(this).closest("tr").children().find("#chkHeader").is(':checked'))
                        ObsOrder += '1|';
                    else
                        ObsOrder += '0|';
                    if (jQuery(this).closest("tr").children().find("#chkCritical").is(':checked'))
                        ObsOrder += '1|';
                    else
                        ObsOrder += '0|';
                    if (jQuery(this).closest("tr").children().find("#chkBold").is(':checked'))
                        ObsOrder += '1|';
                    else
                        ObsOrder += '0|';
                    if (jQuery(this).closest("tr").children().find("#chkUnderLine").is(':checked'))
                        ObsOrder += '1|';
                    else
                        ObsOrder += '0|';
                    if ($(this).closest("tr").children().find("#chkComment").is(':checked'))
                        ObsOrder += '1|';
                    else
                        ObsOrder += '0|';
                    if ($(this).closest("tr").children().find("#chkMicroscopy").is(':checked'))
                        ObsOrder += '1|';
                    else
                        ObsOrder += '0|';
                    ObsOrder += jQuery(this).find('#txtParentid').val() + "#";
                }
            });
            if (ObsOrder == "") {
                //   jQuery("#<%=lblMsg.ClientID %>").text('Please Map Observation');
                modelAlert('Please Map Observation');
                jQuery('input,select').attr('disabled', false);
                return;
            }
            jQuery.ajax({
                url: "../Lab/Services/MapInvestigationObservation.asmx/SaveMapping",
                data: '{ InvestigationID: "' + jQuery("#<%=ddlInvestigation.ClientID %>").val() + '",Order:"' + ObsOrder + '"}', // parameter map
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    data = jQuery.parseJSON(result.d);
                    if (data == "1") {
                        modelAlert('Record Saved Successfully');
                        //jQuery("#<%=lblMsg.ClientID %>").text('Record Saved Successfully');
                        clearform();
                        jQuery('input,select').attr('disabled', false);

                    }
                    if (data == "0") {
                        modelAlert('Record Not Saved');
                        //  jQuery("#<%=lblMsg.ClientID %>").text('Record Not Saved');
                        jQuery('input,select').attr('disabled', false);
                    }
                },
                error: function (xhr, status) {
                    modelAlert('Error occurred, Please contact administrator');
                    // jQuery("#<%=lblMsg.ClientID %>").text('Error occurred, Please contact administrator');
                    jQuery('input,select').attr('disabled', false);
                }
            });
            }
	</script>
	<script type="text/javascript">
	    var Invkeys = [];
	    var InvValues = [];
	    jQuery(function () {
	        var lstInv = jQuery('#<% = lstInvestigation.ClientID %> option');
	        jQuery.each(lstInv, function (index, item) {
	            Invkeys.push(item.value);
	            InvValues.push(item.innerHTML);
	        });
	        jQuery('#<% = txtInvSearch.ClientID %>').keyup(function (e) {
	            var searchtype = jQuery("#<%=rblSearchType.ClientID%> input[type:radio]:checked").val();

	            if (searchtype == "1")
	                searchByCPTCode('', document.getElementById('<%=txtInvSearch.ClientID%>'), '', document.getElementById('<%=lstInvestigation.ClientID%>'), '', InvValues, Invkeys, e)
	            else if (searchtype == "2")
	                searchByFirstChar(document.getElementById('<%=txtInvSearch.ClientID%>'), '', '', document.getElementById('<%=lstInvestigation.ClientID%>'), '', InvValues, Invkeys, e)
		        else if (searchtype == "3")
		            searchByInBetween('', '', document.getElementById('<%=txtInvSearch.ClientID%>'), document.getElementById('<%=lstInvestigation.ClientID%>'), '', InvValues, Invkeys, e)
	            if (jQuery.trim(jQuery('#<% = txtInvSearch.ClientID %>').val()) != "")
	                loadDetail(jQuery('#<% = lstInvestigation.ClientID %>').val());
	            else
	                clearform();
	        });
	    });
	</script>
	 <script type="text/javascript">
	     function clearSearch() {
	         jQuery('#<% = txtInvSearch.ClientID %>').val('');
	         var searchType = jQuery("#<%=rblSearchType.ClientID%> input[type:radio]:checked").val();
	         if (searchType == "1")
	             jQuery('#<% = txtInvSearch.ClientID %>').attr('title', 'Enter Code to Search');
	         else if (searchType == "2")
	             jQuery('#<% = txtInvSearch.ClientID %>').attr('title', 'Enter First Name to Search');
	         else
	             jQuery('#<% = txtInvSearch.ClientID %>').attr('title', 'Enter Name to Search InBetween');
         if (InvValues.length != jQuery('#<% = lstInvestigation.ClientID %> option').length) {
	             jQuery('#<% = lstInvestigation.ClientID %>').empty();
             var list = jQuery('#<% = lstInvestigation.ClientID %>');
             for (i = 0; i < InvValues.length; i++) {
                 var temp = '<option value="' + Invkeys[i] + '">' + InvValues[i] + '</option>';
                 list.append(temp);
             }
         }

     }
			</script>
	<script type="text/javascript">
	    jQuery(function () {
	        jQuery("#chkNewInv").click(function () {
	            //BindSampleType();
	            clearform3();
	            showType();
	            if (jQuery(this).attr("checked")) {
	                jQuery("#<%=txtInv.ClientID %>").attr('disabled', false);
	                jQuery("#chkActive").attr('checked', 'checked');
	                jQuery("#<%=lstInvestigation.ClientID %>,#<%=ddlDepartment.ClientID %>,#chkActive").attr('disabled', true);
                }
                else {
                    jQuery("#<%=txtInv.ClientID %>").attr('disabled', true);
	                jQuery("#chkActive").removeAttr('checked', 'checked');
	                jQuery("#<%=lstInvestigation.ClientID %>,#<%=ddlDepartment.ClientID %>,#chkActive").attr('disabled', false);
                }
	        });
	    });
	</script>
	<script id="tb_InvestigationItems_popup" type="text/html">
        <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_grdLabSearch_popup" 
    style="border-collapse:collapse;width:100%;">
		<tr >
			<th class="GridViewHeaderStyle" scope="col" style="width:20px;">S.No.</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:50px;">From Age(Days)</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:50px;">To Age(Years)</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:50px;">To Age(Days)</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:50px;">Min. Reading</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:50px;">Max. Reading </th>
			<th class="GridViewHeaderStyle" scope="col" style="width:50px;">Min. Critical</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:50px;">Max. Critical </th>
			<th class="GridViewHeaderStyle" scope="col" style="width:20px;">Reading Format</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:200px;">Display Reading</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:50px;">Default Reading </th>
			<th class="GridViewHeaderStyle" scope="col" style="width:50px;">Add</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:50px;">Remove</th>				
</tr>
       <#     
              var dataLength=ObsDetail.length;
              window.status="Total Records Found :"+ dataLength;
              var objRow;   
        for(var j=0;j<dataLength;j++)
        {

        objRow = ObsDetail[j];
        
         
            #>
                    <tr id="tr1"  >
<td class="GridViewLabItemStyle"><#=j+1#></td>
<td class="GridViewLabItemStyle" style="width:50px;"><span id="lblFromAge" ><#=objRow.FromAge#></span></td>
<td class="GridViewLabItemStyle"><input id="txtToAgeyears" type="text" style="width: 50px" value="<#=objRow.ToAgeyears#>" autocomplete="off" onkeyup="CalculateAgeOnDays(this)" onlynumber="3" decimalplace="2" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event)" max-value="180" 
    <#
								 if(objRow.ToAge != ''){#>
									 disabled="disabled" <#} 
								  #> 
    /></td>
<td class="GridViewLabItemStyle" style="width:50px;"><input id="txtToAge"  style="width:50px; display:none;" type="text" value="<#=objRow.ToAge#>" maxlength="5" size="6" autocomplete="off" /><span id="lblToAge" ><#=objRow.ToAge#></span></td>
<td class="GridViewLabItemStyle" style="width:50px;"><input id="txtMinReading"  style="width:50px;" type="text" value="<#=objRow.MinReading#>" maxlength="20" size="7" autocomplete="off"  /></td>
<td class="GridViewLabItemStyle" style="width:50px;"><input id="txtMaxReading"   style="width:50px;" type="text" value="<#=objRow.MaxReading#>" maxLength="20" size="7" autocomplete="off" /></td>
<td class="GridViewLabItemStyle" style="width:50px;"><input id="txtMinCritical"  style="width:50px;" type="text" value="<#=objRow.MinCritical#>" maxLength="6" autocomplete="off" /></td>
<td class="GridViewLabItemStyle" style="width:50px;"><input id="txtMaxCritical"  style="width:50px;" type="text" value="<#=objRow.MaxCritical#>" maxLength="6" autocomplete="off" /></td>
<td class="GridViewLabItemStyle" style="width:50px;"><input id="txtReadingFormat"  style="width:50px;" type="text" value="<#=objRow.ReadingFormat#>" maxLength="100" autocomplete="off" /></td>
<td class="GridViewLabItemStyle" style="width:50px;"><textarea id="txtDisplayReading" rows="1"  style="width:300px;" type="text"  autocomplete="off"><#=objRow.DisplayReading#></textarea></td>
<td class="GridViewLabItemStyle" style="width:50px;"><input id="txtDefaultReading"  style="width:50px;" value="<#=objRow.DefaultReading#>" maxLength="200"  autocomplete="off" /></td>

<td id="Td2" class="GridViewLabItemStyle" style="width:50px;"><img src="../../Images/ButtonAdd.png" onclick="AddDetail();" /></td>
<td id="Td3" class="GridViewLabItemStyle" style="width:20px;"><img src="../../Images/Delete.gif" onclick="RmvDetail();" /></td>


 <#}#>
 
</tr>

            

     </table>  
    </script>
    <script>
        function BindMachine() {
            serverCall('MapInvestigationObservationNew.aspx/BindMachine', { }, function (response) {
                var ddlMachine_popup = $('#<%=ddlMachine_popup.ClientID%>');
                $('#<%=ddlMachine_popup.ClientID%> option').remove();
                var response = JSON.parse( response)
                if (response.length > 0) {
                    $.each(response, function (key, value) {
                        ddlMachine_popup.append($("<option></option>").val(value.VALUE).html(value.TEXT));
                    });
                }
            });
        }
    </script>
</asp:Content>
