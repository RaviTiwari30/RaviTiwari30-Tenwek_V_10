<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master" CodeFile="ManagePackage.aspx.cs" Inherits="Design_EDP_ManagePackage" ClientIDMode="Static" %>


<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" EnableScriptGlobalization="true"
        EnableScriptLocalization="true">
    </cc1:ToolkitScriptManager>
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $('#txtFrom').change(function () {
                ChkDate();
            });
            $('#txtTo').change(function () {
                ChkDate();
            });
            //  $('#ddlPackage').css('display', 'none');

            //Load Schedule Charges
            //Load Data
            LoadCategory();
            LoadSubCategory();
            LoadItems();
            BindPackage();
            $('#rdbItem :radio').click(function () {
                LoadCategory();
                LoadSubCategory();
                LoadItems();
            });

            $('#ddlcategory').change(function () {
                LoadSubCategory();
                LoadItems();
            });
            $('#ddlSubcategory').change(function () {
                LoadItems();
            });


            //Hide Show 
            $('#rbtNewEdit :radio').click(function () {

                ResetAllControl();

                if ($('#rbtNewEdit :radio[Checked]').val() == 1) {
                    //  $('#ddlPackage').css('display', 'none');
                    $('#txtPkg').css('display', '');

                }
                else {

                    BindPackage();
                    $('#txtPkg').css('display', 'none');
                    $('#ddlPackage').css('display', '');



                }
            });
            $('#ddlPackage').change(function () {


                if ($('#ddlPackage').val() == "0") {
                    $('#rdbActive').css('display', 'none');
                    ResetAllControl();
                }
                else {
                    ResetAllControl();
                    $('#txtPkg').css('display', 'block');
                    $('#txtPkg').val($('#ddlPackage option:selected').text());
                    $('#rdbActive').css('display', 'Block');
                    BindPackageOtherDetail();
                    bindPackageDetail();
                    bindPackageDocDetail();

                }
            });

        });
        function BindPackage() {
            $.ajax({
                url: "Services/EDP.asmx/BindPackage",
                data: '',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = jQuery.parseJSON(mydata.d);
                    if (data != null) {
                        $("#ddlPackage").empty().append('<option selected="selected" value="0">Select</option>');
                        for (var i = 0; i < data.length; i++) {
                            $('#ddlPackage').append($("<option></option>").val(data[i].PackageID).html(data[i].Name));
                        }
                    }
                }
            });
        }
        function BindPackageOtherDetail() {
            $.ajax({
                url: "../common/CommonService.asmx/BindPackageOtherDetail",
                data: '{PackageID:"' + $("#ddlPackage").val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = jQuery.parseJSON(mydata.d);
                    if (data != null) {
                        $('#txtFrom').val(data[0].FromDate);
                        $('#txtTo').val(data[0].ToDate);
                        $('#txtCptcode').val(data[0].ItemCode);

                        $('#rdbActive :radio[value="' + data[0].IsActive + '"]').attr("checked", "checked");
                    }
                }
            });
        }
        function bindPackageDetail() {

            $.ajax({
                url: "../Common/CommonService.asmx/bindOPDPackageEdit",
                data: '{PackageID:"' + $("#ddlPackage").val() + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: true,
                dataType: "json",
                success: function (result) {
                    PackageData = jQuery.parseJSON(result.d);
                     if (PackageData != null) {
                        $('#tbSelected').css('display', 'block');

                        if (PackageData.length > 0) {
                            $('#chkVaccination').prop('checked', PackageData[0].IsVaccinationAllow);
                            $('#chkConsumables').prop('checked', PackageData[0].IsConsumablesAllow);
                        }


                        for (var i = 0; i < PackageData.length; i++) {

                            $('#tbSelected').append('<tr><td class="GridViewLabItemStyle"><span id="ItemName">' + PackageData[i].Item + '</span><span id="ItemID" style="display:none">' + PackageData[i].ItemID + '</span><span id="InvestigationID" style="display:none">' + PackageData[i].Investigation_Id + '</span></td><td class="GridViewLabItemStyle">1</td><td class="GridViewLabItemStyle"><img id="imgRemove" onclick="RemoveRows(this)"  src="../../Images/Delete.gif" style="cursor:pointer"/></td></tr>');
                        }
                    }
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;

                }
            });

        }
        function bindPackageDocDetail() {
            $.ajax({
                url: "../Common/CommonService.asmx/bindPackageDocDetail",
                data: '{PackageID:"' + $("#ddlPackage").val() + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: true,
                dataType: "json",
                success: function (result) {
                    PackageDocData = jQuery.parseJSON(result.d);
                    if (PackageDocData != null) {
                        for (var i = 0; i < PackageDocData.length; i++) {
                            $('#tbDoctorVisit').css('display', 'block');

                            $('#tbDoctorVisit').append('<tr><td class="GridViewLabItemStyle">' + PackageDocData[i].VisitType + '<span id="SubCategoryID"  style="display:none">' + PackageDocData[i].SubCategoryID + '</span></td><td class="GridViewLabItemStyle">' + PackageDocData[i].Department + '<span id="DocDepartmentID" style="display:none">' + PackageDocData[i].DocDepartmentID + '</span></td><td class="GridViewLabItemStyle">' + PackageDocData[i].DName + '<span id="DoctorID" style="display:none">' + PackageDocData[i].DoctorID + '</span></td><td class="GridViewLabItemStyle"><img id="imgRemove"  onclick="RemoveDoctor(this)" src="../../Images/Delete.gif" style="cursor:pointer" /></td></tr>');
                        }
                    }
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;

                }
            });
        }
        function LoadCategory() {
            //Clear Dropdowne first
            $('#ddlcategory option').remove();
            var Type = $('#rdbItem :radio[Checked]').val();
            $.ajax({
                url: "../common/CommonService.asmx/BindCategory",
                data: '{Type:"' + Type + '"}',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = jQuery.parseJSON(mydata.d);
                    $("#ddlcategory").empty().append('<option selected="selected" value="0">Select</option>');
                    for (var i = 0; i < data.length; i++) {
                        $('#ddlcategory').append($("<option></option>").val(data[i].CategoryID).html(data[i].Name));
                    }

                }
            });
        }
        function LoadSubCategory() {
            //Clear Dropdowne first
            $('#ddlSubcategory option').remove();
            var Type = $('#rdbItem :radio[Checked]').val();
            var CategoryID = $('#ddlcategory').val();


            $.ajax({
                url: "../common/CommonService.asmx/BindSubCategory",
                data: '{Type:"' + Type + '",CategoryID:"' + CategoryID + '"}',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = jQuery.parseJSON(mydata.d);
                    $("#ddlSubcategory").empty().append('<option selected="selected" value="0">Select</option>');
                    for (var i = 0; i < data.length; i++) {
                        $('#ddlSubcategory').append($("<option></option>").val(data[i].SubCategoryID).html(data[i].Name));
                    }

                }
            });
        }
        function LoadItems() {

            var Type = $('#rdbItem :radio[Checked]').val();
            var CategoryID = $('#ddlcategory').val();
            var SubCategoryID = $('#ddlSubcategory').val();
            $('#lstInv option').remove();

            $.ajax({
                url: "../common/CommonService.asmx/LoadOPD_All_Items",
                data: '{Type:"' + Type + '",CategoryID:"' + CategoryID + '",SubCategoryID:"' + SubCategoryID + '"}',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = jQuery.parseJSON(mydata.d);

                    for (var i = 0; i < data.length; i++) {
                        $('#lstInv').append($("<option></option>").val(data[i].PackageItemID).html(data[i].item));
                    }

                }
            });
        }
        function AddItem() {
            debugger;
            if ($('#lstInv').find('option:selected').val() === null || $('#lstInv').find('option:selected').val() === undefined || $('#lstInv').find('option:selected').val() == "") {
                return;
            }
            $("#lblMsg").text('');
            var ItemID = $.trim($('#lstInv').find('option:selected').val().split('#')[1]);
            if (CheckDuplicateItem(ItemID)) {
                $("#lblMsg").text('Selected Item Already Added!');
                return;
            }
            var InvestigationID = $.trim($('#lstInv').find('option:selected').val().split('#')[0]);
            var ItemName = $.trim($('#lstInv').find('option:selected').val().split('#')[2]);
            $('#tbSelected').css('display', 'block');
            $('#tbSelected').append('<tr><td class="GridViewLabItemStyle"><span id="ItemName">' + ItemName + '</span><span id="ItemID" style="display:none">' + ItemID + '</span><span id="InvestigationID" style="display:none">' + InvestigationID + '</span></td><td class="GridViewLabItemStyle">1</td><td><img id="imgRemove" onclick="RemoveRows(this)"  src="../../Images/Delete.gif" /></td></tr>');
        }

        function RemoveRows(rowid) {
            $(rowid).closest('tr').remove();
            if ($('#tbSelected tr:not(#Header)').length == 0) {
                $('#tbSelected').hide();
            }
            $("#lblMsg").text('');
        }
        function CheckDuplicateItem(ItemID) {

            var count = 0;
            $('#tbSelected tr:not(#Header)').each(function () {

                if ($(this).find('#ItemID').text().trim() == ItemID) {

                    count = count + 1;

                }
            });
            if (count == 0)
                return false;
            else
                return true;
        }
        function AddConsultant() {


            if ($('#ddlAppointmentType option:selected').text() == "Select") {
                $("#lblMsg").text('Select Doctor Visit');
                return;
            }
            if ($('#ddlDepartment option:selected').text() == "Select") {
                $("#lblMsg").text('Select Doctor Department');
                return;
            }
            if (CheckDuplicateVisit($('#ddlAppointmentType').val(), $('#ddlDepartment').val(), $('#ddlDoctorList').val())) {
                $("#lblMsg").text('Visit & Doctor Already Selected!');
                return;
            }

            $('#tbDoctorVisit').css('display', '');


            $('#tbDoctorVisit').append('<tr><td class="GridViewLabItemStyle">' + $('#ddlAppointmentType option:selected').text() + '<span id="SubCategoryID"  style="display:none">' + $('#ddlAppointmentType').val() + '</span></td><td class="GridViewLabItemStyle" >' + $('#ddlDepartment option:selected').text() + '<span id="DocDepartmentID" style="display:none">' + $('#ddlDepartment').val() + '</span></td><td class="GridViewLabItemStyle">' + $('#ddlDoctorList option:selected').text() + '<span id="DoctorID" style="display:none">' + $('#ddlDoctorList').val() + '</span></td><td><img id="imgRemove"  onclick="RemoveDoctor(this)" src="../../Images/Delete.gif" /></td></tr>');
        }
        function RemoveDoctor(rowid) {
            $(rowid).closest('tr').remove();
            if ($('#tbDoctorVisit tr:not(#DocHeader)').length == 0) {
                $('#tbDoctorVisit').hide();

            }
            $("#lblMsg").text('');
        }
        function CheckDuplicateVisit(AppointmentType, Department, Doctor) {

            var count = 0;
            $('#tbDoctorVisit tr:not(#DocHeader)').each(function () {

                if ($(this).find('#SubCategoryID').text().trim() == AppointmentType && $(this).find('#DocDepartmentID').text().trim() == Department && $(this).find('#DoctorID').text().trim() == Doctor) {

                    count = count + 1;

                }
            });
            if (count == 0)
                return false;
            else
                return true;
        }
        function Save() {

            var PackageID = '';
            //Check New Package or Edit Package
            if ($('#rbtNewEdit :radio[Checked]').val() == 2) {

                if ($('#ddlPackage').val() == "0") {
                    $("#lblMsg").text('Select Package');
                    return;
                }
                PackageID = $('#ddlPackage').val();

            }
            if ($('#txtPkg').val() == '') {
                $("#lblMsg").text('Package Name Required');
                $('#txtPkg').focus();
                return;
            }

            if ($('#tbSelected tr:not(#Header)').length == 0) {
                $("#lblMsg").text('Select Items');
                return;
            }
            $('#btnSave').prop('disabled', 'disabled');

            var PackageInfo = [];
            PackageInfo.push({ "PackageID": PackageID, "PackageName": $('#txtPkg').val(), "ItemCode": $('#txtCptcode').val(), "FromDate": $('#txtFrom').val(), "ToDate": $('#txtTo').val(), "Active": $('#rdbActive :radio[Checked]').val() });

            var data = new Array();
            var obj = new Object();
            $('#tbSelected tr:not(#Header)').each(function () {
                obj.ItemName = $(this).find('#ItemName').text();
                obj.ItemID = $(this).find('#ItemID').text();
                obj.SubCategoryID = $(this).find('#SubCategoryID').text();
                obj.InvestigationID = $(this).find('#InvestigationID').text();
                obj.Quantity = 1;
                data.push(obj);
                obj = new Object();
            });

            var Docdata = new Array();
            var doctorObj = new Object();
            $('#tbDoctorVisit tr:not(#DocHeader)').each(function () {
                doctorObj.SubCategoryID = $(this).find('#SubCategoryID').text();
                doctorObj.DocDepartmentID = $(this).find('#DocDepartmentID').text();
                doctorObj.DoctorID = $(this).find('#DoctorID').text();
                Docdata.push(doctorObj);
                doctorObj = new Object();
            });


            var IsConsumablesAllow = Number(($('#chkVaccination').prop('checked')?1:0));
            var IsVaccinationAllow = Number(($('#chkConsumables').prop('checked') ? 1 : 0));


            $.ajax({
                type: "POST",
                data: JSON.stringify({ Packageinfo: PackageInfo, ItemDetail: data, DoctorVisitDetail: Docdata, IsConsumablesAllow: IsConsumablesAllow, IsVaccinationAllow: IsVaccinationAllow }),
                url: "Services/EDP.asmx/SavePackage",
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                timeout: 120000,
                async: false,
                success: function (result) {
                    data = (result.d);
                    if (data == "1") {
                        ResetAllControl();
                        $("#lblMsg").text('Record Saved Successfully');
                        $('#rbtNewEdit :radio[value="1"]').attr("checked", "checked");
                        //  $("#ddlPackage").css('display', 'none');
                        $('#ddlPackage option[value="0"]').attr('selected', 'selected');
                    }
                    else if (data == "5") {
                        $("#lblMsg").text('Package Already Exits !!!');
                    }
                    else {
                        $("#lblMsg").text('Error occurred, Please contact administrator');

                    }
                    $('#btnSave').removeProp('disabled');
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;
                    $("#lblMsg").text('Error');
                    $('#btnSave').removeProp('disabled');
                }

            });

        }
        function ResetAllControl() {
            $('#lblMsg').text('');
            $('#txtPkg').val('');
            $('#txtCptcode').val('');

            $('#tbSelected tr:not(#Header)').remove();
            $('#tbSelected').hide();
            $('#tbDoctorVisit tr:not(#DocHeader)').remove();
            $('#tbDoctorVisit').hide();
            $('#ddlAppointmentType option[value="Select"]').attr('selected', 'selected');
            $('#ddlDepartment option[value="Select"]').attr('selected', 'selected');
            $('#ddlDoctorList option[value=""]').attr('selected', 'selected');
            $('#rdbActive :radio[value="1"]').attr("checked", "checked");
            $('#chkVaccination').prop('checked', 0);
            $('#chkConsumables').prop('checked', 0);

        }
        function MoveUpAndDownText(textbox2, listbox2) {

            var f = document.theSource;
            var listbox = listbox2;
            var textbox = textbox2;

            if (event.keyCode == 13) {
                textbox.value = "";
                AddItem();
            }
            if (event.keyCode == '38' || event.keyCode == '40') {
                if (event.keyCode == '40') {
                    for (var m = 0; m < listbox.length; m++) {
                        if (listbox.options[m].selected == true) {
                            if (m + 1 == listbox.length) {
                                return;
                            }
                            listbox.options[m + 1].selected = true;
                            textbox.value = listbox.options[m + 1].text;

                            return;
                        }
                    }
                    listbox.options[0].selected = true;
                }
                if (event.keyCode == '38') {
                    for (var m = 0; m < listbox.length; m++) {
                        if (listbox.options[m].selected == true) {
                            if (m == 0) {
                                return;
                            }
                            listbox.options[m - 1].selected = true;
                            textbox.value = listbox.options[m - 1].text;
                            return;
                        }
                    }
                }
            }
        }
        function suggestName(textbox2, listbox2, level) {
            if (isNaN(level)) { level = 1 }
            if (event.keyCode != 38 && event.keyCode != 40 && event.keyCode != 13 && event.keyCode != 8) {
                var listbox = listbox2;
                var textbox = textbox2;

                var soFar = textbox.value.toString();
                var soFarLeft = soFar.substring(0, level).toLowerCase();
                var matched = false;
                var suggestion = '';
                var m
                for (m = 0; m < listbox.length; m++) {
                    suggestion = listbox.options[m].text.toString().split('#')[1].trim();
                    suggestion = suggestion.substring(0, level).toLowerCase();
                    if (soFarLeft == suggestion) {
                        listbox.options[m].selected = true;
                        matched = true;
                        break;
                    }
                }
                if (matched && level < soFar.length) { level++; suggestName(textbox, listbox, level) }
            }
        }

        function ChkDate() {
            $.ajax({
                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#txtFrom').val() + '",DateTo:"' + $('#txtTo').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#butSave').text('To date can not be less than from date!');
                        $('#butSave').attr('disabled', 'disabled');
                    }
                    else {
                        $('#lblMsg').text('');
                        $('#butSave').removeAttr('disabled');

                    }
                }
            });

        }

        function ChkPackage() {

            if ($("#<%=rbtNewEdit.ClientID%> input[type=radio]:checked").next().text() == "New") {
                if ($.trim($("#<%=txtPkg.ClientID%>").val()) == "") {
                    $("#lblMsg").text('Please Enter Package Name');
                    $("#<%=txtPkg.ClientID%>").focus();
                    return false;
                }


            }

            else {
                if ($("#<%=ddlPackage.ClientID%>").val() == "0") {
                    $("#lblMsg").text('Please Select Package Name');
                    $("#<%=ddlPackage.ClientID%>").focus();
                    return false;
                }
            }
            document.getElementById('butSave').disabled = true;
            document.getElementById('butSave').value = 'Submitting...';
            __doPostBack('butSave', '');
        }


        $(document).ready(function () {
            $("#<%=ddlDepartment.ClientID%>").change(function () {

                $('#lblAmount').text('');
                //$("#ddlAppointmentType").val("-Select-");
                $("#<%=ddlDoctorList.ClientID%> option").remove();
                var ComplaintName = $("#ddlDoctorList");
                $.ajax({
                    url: "../Common/CommonService.asmx/bindDoctorDept",
                    data: '{ Department: "' + $("#<%=ddlDepartment.ClientID%> option:selected").text() + '"}', // parameter map
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        ComplaintData = jQuery.parseJSON(result.d);
                        if (ComplaintData > "0") {
                            $("#ddlDoctorList").empty().append('<option selected="selected" value=""></option>');
                            for (i = 0; i < ComplaintData.length; i++) {
                                ComplaintName.append($("<option></option>").val(ComplaintData[i].DoctorID).html(ComplaintData[i].Name));
                            }
                        }
                    },
                    error: function (xhr, status) {
                        alert("Error");
                        window.status = status + "\r\n" + xhr.responseText;
                        return false;
                    }
                });
            });
        });
    </script>

    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>OPD Package Master</b>&nbsp;<br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Package Details
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Select Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rbtNewEdit" runat="server" Font-Bold="True" Font-Names="Verdana"
                                RepeatDirection="Horizontal" ToolTip="Select New Or Edit To Update Package Details">
                                <asp:ListItem Selected="True" Value="1">New</asp:ListItem>
                                <asp:ListItem Value="2">Edit</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Package
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlPackage" runat="server" ToolTip="Select Package"></asp:DropDownList>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtPkg" runat="server" CssClass="required"
                                ToolTip="Enter Package Name" MaxLength="95" Width="95%"></asp:TextBox>

                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Valid From
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtFrom" runat="server" ClientIDMode="Static"
                                ToolTip="Click To Select Valid Date From"></asp:TextBox>
                            <cc1:CalendarExtender ID="FromDateCal" TargetControlID="txtFrom" Format="dd-MMM-yyyy" Animated="true" runat="server"></cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Valid To
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtTo" runat="server" ClientIDMode="Static"
                                ToolTip="Click To Select Valid Date To"></asp:TextBox>
                            <cc1:CalendarExtender ID="ToDateCal" TargetControlID="txtTo" Format="dd-MMM-yyyy" Animated="true" runat="server"></cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                CPT Code
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtCptcode" runat="server" MaxLength="10"></asp:TextBox>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>


            <table style="width: 100%; border-collapse: collapse">
                <tr>
                    <td style="width: 30%; text-align: left; padding-left: 195px;" colspan="2">
                        <asp:RadioButtonList ID="rdbActive" runat="server" Style="display: none" RepeatDirection="Horizontal"
                            ToolTip="Select Active Or In-Active To Update Achedule Charges">
                            <asp:ListItem Selected="True" Value="1">Active</asp:ListItem>
                            <asp:ListItem Value="0">In-Active</asp:ListItem>
                        </asp:RadioButtonList>
                    </td>
                </tr>
            </table>

        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Package Detail
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-9">
                            <asp:RadioButtonList ID="rdbItem" runat="server" RepeatDirection="Horizontal" RepeatLayout="Flow">
                                <asp:ListItem Selected="True" Text="Investigations" Value="1" />
                                <asp:ListItem Text="Procedures" Value="2" />
                                <asp:ListItem Text="Other Charges" Value="3" />
                                <asp:ListItem Text="All" Value="4" />
                            </asp:RadioButtonList>
                        </div>
                        <div class="col-md-2">
                            <label class="pull-left">
                                Category
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <asp:DropDownList ID="ddlcategory" runat="server" Width="175px">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label>

                                <input type="checkbox" id="chkVaccination" />
                                Vaccination
                            </label>
                            <input id="btnSearch" class="ItDoseButton" type="button" value="CPOE Investigations" style="display: none" />
                        </div>
                        <div class="col-md-3">
                            <label>
                                <input type="checkbox" id="chkConsumables" />
                                Consumables
                            </label>

                        </div>

                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Subcategory
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlSubcategory" runat="server" Width="175px">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                By First Name 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtSearch" runat="server" MaxLength="50" AutoCompleteType="Disabled"
                                onKeyDown="MoveUpAndDownText(ctl00$ContentPlaceHolder1$txtSearch,ctl00$ContentPlaceHolder1$lstInv);"
                                onkeyup="suggestName(ctl00$ContentPlaceHolder1$txtSearch,ctl00$ContentPlaceHolder1$lstInv);"
                                TabIndex="21" ToolTip="Enter First Name To Search Investigation" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                By CPT Code
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="TextBox1" runat="server" MaxLength="50" AutoCompleteType="Disabled"
                                ToolTip="Enter CPT Code To Search Investigation" />
                            <asp:Label ID="lblGovTaxPer" Style="display: none" runat="server"></asp:Label>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
            <table style="border-collapse: collapse">
                <tr style="text-align: left">
                    <td style="width:22%;text-align:center">
                        Select Item 
                    </td>
                    <td style="text-align: left">
                        <asp:ListBox ID="lstInv" runat="server" CssClass="ItDoseDropdownbox" Height="200px" Width="320px" />
                    </td>
                    <td>
                        <input type="button" id="btnAdd" onclick="AddItem()" value="Add" class="ItDoseButton" />

                    </td>
                    <td style="width: 100%; vertical-align: top">
                        <br />
                        <div id="PackageOutput" style="max-height: 200px; overflow-y: auto; overflow-x: hidden;">
                            <table id="tbSelected" rules="all" border="1" style="border-collapse: collapse; width: 100%; display: none" class="GridViewStyle">
                                <tr id="Header">
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 700px; text-align: left">&nbsp;Item Name</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 60px; text-align: center">Quantity</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 30px; text-align: center"></th>
                                </tr>

                            </table>
                        </div>
                    </td>
                </tr>
            </table>

        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Doctor Consultation Detail
            </div>
            <table style="width: 100%">
                <tr>
                    <td style="width: 25%; text-align: center">
                        <strong>Doctor Visit</strong></td>
                    <td style="width: 25%; text-align: center">
                        <strong>Department</strong></td>
                    <td style="width: 25%; text-align: center">
                        <strong>Doctor</strong></td>
                    <td style="width: 25%; text-align: center">&nbsp;</td>
                </tr>
                <tr>
                    <td style="width: 25%; text-align: center">
                        <asp:DropDownList ID="ddlAppointmentType" runat="server" TabIndex="18" Width="180px" CssClass="required"
                            class="ddl" ClientIDMode="Static" ToolTip="Select Visit Type">
                        </asp:DropDownList>
                        <%--<asp:Label ID="Label1" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>--%>    
                    </td>
                    <td style="width: 25%; text-align: center">
                        <asp:DropDownList ID="ddlDepartment" runat="server" TabIndex="18" Width="180px" CssClass="required"
                            class="ddl" ClientIDMode="Static" ToolTip="Select Department">
                        </asp:DropDownList>
                        <%--<asp:Label ID="Label2" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>--%>
                    
                    </td>
                    <td style="width: 25%; text-align: center">
                        <asp:DropDownList ID="ddlDoctorList" ClientIDMode="Static" runat="server"
                            TabIndex="19" Width="180px" ToolTip="Select Doctor">
                        </asp:DropDownList>

                    </td>
                    <td style="width: 25%; text-align: center">
                        <input type="button" id="btnAddConsultant" onclick="AddConsultant()" value="Add" class="ItDoseButton" /></td>
                </tr>
                <tr>
                    <td colspan="4" style="width: 100%; text-align: center">
                        <table id="tbDoctorVisit" cellspacing="0" rules="all" border="1" style="border-collapse: collapse; width: 950px; display: none" class="GridViewStyle">
                            <tr id="DocHeader">

                                <th class="GridViewHeaderStyle" scope="col" style="width: 300px; text-align: left">&nbsp;&nbsp;Doctor Visit</th>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 300px; text-align: left">&nbsp;&nbsp;Department</th>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 300px; text-align: left">&nbsp;&nbsp;Doctor</th>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 50px; text-align: left"></th>
                            </tr>

                        </table>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: center" colspan="3">&nbsp;</td>
                    <td style="width: 25%; text-align: center">&nbsp;</td>
                </tr>
            </table>
        </div>



        <div class="POuter_Box_Inventory textCenter">

            <input type="button" value="Save" id="butSave" onclick="Save()" class="save margin-top-on-btn" />


        </div>


    </div>



</asp:Content>
