<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="PatientSearchMRD.aspx.cs" Inherits="Design_MRD_PatientSearchMRD" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">
        $(function () {
            $('#ucFromDate').change(function () {
                ChkDate();
            });
            $('#ucToDate').change(function () {
                ChkDate();
            });
        });
        function ChkDate() {
            $.ajax({
                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#ucFromDate').val() + '",DateTo:"' + $('#ucToDate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#<%=lblMsg.ClientID %>').text('To date can not be less than from date!');
                        $('#<%=btnSearch.ClientID %>').attr('disabled', 'disabled');

                    }
                    else {
                        $('#<%=lblMsg.ClientID %>').text('');
                        $('#<%=btnSearch.ClientID %>').removeAttr('disabled');
                    }
                }
            });

        }

        $(document).ready(function () {
            $('#ucFromDateOPD').change(function () {
                ChkDate1();

            });

            $('#ucToDateOPD').change(function () {
                ChkDate1();

            });

        });
        function ChkDate1() {
            $.ajax({
                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#ucFromDateOPD').val() + '",DateTo:"' + $('#ucToDateOPD').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#<%=lblMsg.ClientID %>').text('To date can not be less than from date!');
                        $('#<%=btnSearch.ClientID %>').attr('disabled', 'disabled');
                    }
                    else {
                        $('#<%=lblMsg.ClientID %>').text('');
                        $('#<%=btnSearch.ClientID %>').removeAttr('disabled');
                    }
                }
            });
        }
    </script>
    <script type="text/javascript">
        function WriteToFile(data, name, txtprint) {

            var n = document.getElementById(txtprint).value;

            try {
                var fso = new ActiveXObject("Scripting.FileSystemObject");
                for (var i = 0; i < n; i++) {
                    var s = fso.CreateTextFile("C:\\BarCode\\" + name + i + ".txt", true);
                    s.WriteLine(data);

                }
                s.Close();


            }
            catch (e) { }
        }

        function printNBarcode() {

        }

    </script>
    <script type="text/javascript">
        function doClick(buttonName, e) {
            //the purpose of this function is to allow the enter key to 
            //point to the correct button to click.
            var key;

            if (window.event)
                key = window.event.keyCode;     //IE
            else
                key = e.which;     //firefox

            if (key == 13) {
                //Get the button the user wants to have clicked
                var btn = document.getElementById(buttonName);
                if (btn != null) { //If we find the button click it
                    btn.click();
                    event.keyCode = 0
                }
            }
        }
    </script>
    <script type="text/javascript">

        function ReseizeIframe(elem) {
            $modelBlockUI();
            var iframe = document.getElementById("iframePatient");
            var row = $(elem).closest('tr');
            iframe.onload = function () {
                iframe.style.width = '100%';
                iframe.style.height = '100%';
                iframe.style.display = '';
                try {
                    var contentDocument = document.getElementById("iframePatient").contentDocument;
                    contentDocument.getElementById('lblPatientName').innerHTML = row.find('td:eq(9)').text().trim();
                    contentDocument.getElementById('lblPatientID').innerHTML = row.find('td:eq(8)').text().trim();
                    contentDocument.getElementById('lblGender').innerHTML = row.find('td:eq(10)').text().trim().split('/')[1];
                    contentDocument.getElementById('lblAge').innerHTML = row.find('td:eq(10)').text().trim().split('/')[0];
                    $modelUnBlockUI();
                }
                catch (e) {
                    $modelUnBlockUI();
                }
            };
        }
        function ReseizeIframe1(elem) {
            $modelBlockUI();
            var iframe = document.getElementById("iframePatient");
            var row = $(elem).closest('tr');
            iframe.onload = function () {
                iframe.style.width = '100%';
                iframe.style.height = '100%';
                iframe.style.display = '';
                try {
                    var contentDocument = document.getElementById("iframePatient").contentDocument;
                    contentDocument.getElementById('lblPatientName').innerHTML = row.find('td:eq(6)').text().trim();
                    contentDocument.getElementById('lblPatientID').innerHTML = row.find('td:eq(4)').text().trim();
                    //contentDocument.getElementById('lblGender').innerHTML = row.find('td:eq(8)').text().trim().split('/')[1];
                    //contentDocument.getElementById('lblAge').innerHTML = row.find('td:eq(8)').text().trim().split('/')[0];
                    $modelUnBlockUI();
                }
                catch (e) {
                    $modelUnBlockUI();
                }
            };
        }
        function ReseizeIframe2(elem) {
            $modelBlockUI();
            var iframe = document.getElementById("iframePatient");
            var row = $(elem).closest('tr');
            iframe.onload = function () {
                iframe.style.width = '100%';
                iframe.style.height = '100%';
                iframe.style.display = '';
                try {
                    var contentDocument = document.getElementById("iframePatient").contentDocument;
                    contentDocument.getElementById('lblPatientName').innerHTML = row.find('td:eq(5)').text().trim();
                    contentDocument.getElementById('lblPatientID').innerHTML = row.find('td:eq(4)').text().trim();
                    contentDocument.getElementById('lblGender').innerHTML = row.find('td:eq(8)').text().trim();
                    contentDocument.getElementById('lblAge').innerHTML = row.find('td:eq(7)').text().trim();
                    $modelUnBlockUI();
                }
                catch (e) {
                    $modelUnBlockUI();
                }
            };
        }
        function closeIframe() {
            var iframe = document.getElementById("iframePatient");
            iframe.style.width = '0%';
            iframe.style.height = '0%';
            iframe.style.display = 'none';
            iframe.contentWindow.document.write('');
        }
    </script>
    <script type="text/javascript">
        function chkSelectAll(fld) {
            //alert(fld.checked);

            var gridTable = document.getElementById("<%=grdPatient.ClientID %>");
            //alert(gridTable.id);
            var chkList = gridTable.document.getElementsByTagName("input");
            //alert(chkList.length);
            for (var i = 0; i < chkList.length; i++) {
                if (chkList[i].type == "checkbox") {
                    chkList[i].checked = fld.checked;
                }
            }
        }
    </script>
    <script type="text/javascript">
        $("[id*=chkBoxAll]").live("click", function () {
            var chkHeader = $(this);
            var grid = $(this).closest("table");
            $("input[type=checkbox]", grid).each(function () {
                if (chkHeader.is(":checked")) {
                    $(this).not(":disabled").attr("checked", "checked");

                } else {
                    $(this).not(":disabled").removeAttr("checked");

                }
            });
        });
        $("[id*=chkBox]").live("click", function () {
            var grid = $(this).closest("table");
            var chkHeader = $("[id*=chkBoxAll]", grid);
            if (!$(this).is(":checked")) {
                chkHeader.removeAttr("checked");
            } else {
                var totalRow = (($("[id*=chkBox]", grid).length) - 1);
                var disableRow = (totalRow - ($("[id*=chkBox]:checked", grid).not(":disabled").length));
                if (($("[id*=chkBox]", grid).not(":disabled").length - 1) == $("[id*=chkBox]:checked", grid).not(":disabled").length) {
                    chkHeader.attr("checked", "checked");
                }
            }
        });

        $(document).ready(function () {
            show();
        });
        function show() {
            if ($("#<%=rdbselectedtype.ClientID %> input[type=radio]:checked").val() == '1') {
                $("#<%=pnlipd.ClientID %>,#<%=lblColor.ClientID %>,#<%=lblColor1.ClientID %>").show();
                $("#<%=pnlopd.ClientID %>").hide();
                $("#<%=lblColor.ClientID %>").text('Received');
                $("#<%=lblColor1.ClientID %>").text('Not Received');
            }
            if ($("#<%=rdbselectedtype.ClientID %> input[type=radio]:checked").val() == '2') {
                $("#<%=pnlopd.ClientID %>").show();
                $("#<%=pnlipd.ClientID %>,#<%=lblColor.ClientID %>,#<%=lblColor1.ClientID %>").hide();
            }
            if ($("#<%=rdbselectedtype.ClientID %> input[type=radio]:checked").val() == '3') {
                $("#<%=pnlopd.ClientID %>").show();
                $("#<%=pnlipd.ClientID %>,#<%=lblColor.ClientID %>,#<%=lblColor1.ClientID %>").hide();
            }

        }
        function getDate4() {
            $.ajax({
                url: "../common/CommonService.asmx/getDate",
                data: '{}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    $('#<%=ucFromDateOPD.ClientID %>').val(data);
                    $('#<%=ucToDateOPD.ClientID %>').val(data);
                    return;
                }
            });
        }
        $(document).ready(function () {
            $("#<%=rdbselectedtype.ClientID %> input:radio").change(function () {
                if ($('#<%=rdbselectedtype.ClientID %> input[type=radio]:checked').val() == '1') {
                    $('#<%=lblMsg.ClientID %>').text('');
                    $('#<%=btnSearch.ClientID %>').attr('disabled', false);
                    $('#<%=btnSave.ClientID %>').attr('disabled', false);
                    $('#<%=btnReport.ClientID %>').attr('disabled', false);
                    $('#<%=grdgeneral.ClientID %>').hide();
                    $('#<%=grdMRD.ClientID %>').hide();
                    getDate3();
                    function getDate3() {
                        $.ajax({
                            url: "../common/CommonService.asmx/getDate",
                            data: '{}',
                            type: "POST",
                            async: true,
                            dataType: "json",
                            contentType: "application/json; charset=utf-8",
                            success: function (mydata) {
                                var data = mydata.d;
                                $('#<%=ucFromDate.ClientID %>').val(data);
                                $('#<%=ucToDate.ClientID %>').val(data);
                                return;
                            }
                        });
                    }
                }
                if ($('#<%=rdbselectedtype.ClientID %> input[type=radio]:checked').val() == '2') {
                    $('#<%=lblMsg.ClientID %>').text('');
                    $('#<%=btnSearch.ClientID %>,#<%=btnSave.ClientID %>,#<%=btnReport.ClientID %>').attr('disabled', false);
                    $('#<%=grdPatient.ClientID %>,#<%=grdgeneral.ClientID %>,#<%=btnSave.ClientID %>,#<%=btnReport.ClientID %>').hide();
                    $('#<%=txtMrnoOpd.ClientID %>,#<%=txtPatientnameOpd.ClientID %>').val('');
                    getDate4();
                }
                if ($('#<%=rdbselectedtype.ClientID %> input[type=radio]:checked').val() == '3') {
                    $('#<%=lblMsg.ClientID %>').text('');
                    $('#<%=btnSearch.ClientID %>,#<%=btnSave.ClientID %>,#<%=btnReport.ClientID %>').attr('disabled', false);
                    $('#<%=grdPatient.ClientID %>,#<%=grdMRD.ClientID %>,#<%=btnSave.ClientID %>,#<%=btnReport.ClientID %>').hide();
                    $('#<%=txtMrnoOpd.ClientID %>,#<%=txtPatientnameOpd.ClientID %>').val('');
                    getDate4();

                }
            });
        });
        function patientTypeID(el) {
            var pType = el;
            if (pType == 'OPD' || pType == 'ALL') {
                $('#txtTransactionNo').attr('disabled', 'disabled');
                $('#cmbRoom').attr('disabled', 'disabled');
                $('#ddlDischageType').attr('disabled', 'disabled');
                $('#txtTransactionNo').val('');
            }
            else {

                $('#lblipdno').text(el + ' No');
                $('#txtTransactionNo').removeAttr('disabled');
                $('#cmbRoom').removeAttr('disabled');
                $('#ddlDischageType').removeAttr('disabled');
                $('#txtTransactionNo').val('');
            }
        }
          
    </script>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sm" runat="server" />
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Patient Search MRD</b>
            <asp:Label ID="lblMsg" ClientIDMode="Static" runat="server" CssClass="ItDoseLblError" />
            <table style="width: 100%;display:none" >
                <tr style="text-align: center">
                    <td align="center">
                        <asp:RadioButtonList ID="rdbselectedtype" runat="server" RepeatColumns="3" RepeatDirection="Horizontal"
                            onclick="show();">
                            <asp:ListItem Text="IPD" Value="1" Selected="True"></asp:ListItem>
                            <asp:ListItem Text="OPD" Value="2"></asp:ListItem>
                            <asp:ListItem Text="General" Value="3"></asp:ListItem>
                        </asp:RadioButtonList>
                    </td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="Purchaseheader">
                Search Criteria&nbsp;
            </div>
            <asp:Panel ID="pnlipd" runat="server" Style="display: none">
                <div class="row">
                    <div class="col-md-1"></div>
                    <div class="col-md-22">
                        <div class="row">
                             <div class="col-md-3">
                             <label class="pull-left">
                                 Patient Type
                             </label>
                             <b class="pull-right">:</b>
                         </div>
                         <div class="col-md-5">
                             <asp:DropDownList ID="ddlPatientType" runat="server" ClientIDMode="Static" onchange="patientTypeID(this.value)"></asp:DropDownList>
                         </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    <asp:Label ID="lblmrno" Text="UHID" runat="server"></asp:Label>
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtPatientID" runat="server" AutoCompleteType="Disabled" ToolTip="Enter UHID"
                                    Width="" TabIndex="1"></asp:TextBox>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    <asp:Label ID="lblpatientname" Text="Patient Name" runat="server"></asp:Label>
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtName" runat="server" AutoCompleteType="Disabled" TabIndex="2"
                                    ToolTip="Enter Patient Name" Width=""></asp:TextBox>
                            </div>
                            
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    <asp:Label Text="IPD No." runat="server" ID="lblipdno" ClientIDMode="Static"></asp:Label>
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtTransactionNo" runat="server" MaxLength="10" ToolTip="Enter IPD No."
                                     ClientIDMode="Static" TabIndex="8"></asp:TextBox>
                               
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    <asp:Label Text="Age From" ID="lblagefrom" runat="server"></asp:Label>
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtAgeFrom" runat="server" AutoCompleteType="Disabled" TabIndex="4"
                                    ToolTip="Enter Age From" Width="81px"></asp:TextBox><asp:DropDownList ID="ddlAgeFrom"
                                        runat="server" TabIndex="5" Width="143px" ToolTip="Select Age From">
                                        <asp:ListItem Value="YRS">YRS</asp:ListItem>
                                        <asp:ListItem Value="MONTH(S)">MONTH(S)</asp:ListItem>
                                        <asp:ListItem>DAYS(S)</asp:ListItem>
                                    </asp:DropDownList>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    <asp:Label Text="Age To" runat="server" ID="lblto"></asp:Label>
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtAgeTo"
                                    runat="server" AutoCompleteType="Disabled" ToolTip="Enter Age To" Width="81px"
                                    TabIndex="6"></asp:TextBox><asp:DropDownList ID="ddlAgeTo" runat="server" TabIndex="6"
                                        ToolTip="Seelct Age To" Width="143px">
                                        <asp:ListItem Value="YRS">YRS</asp:ListItem>
                                        <asp:ListItem Value="MONTH(S)">MONTH(S)</asp:ListItem>
                                        <asp:ListItem>DAYS(S)</asp:ListItem>
                                    </asp:DropDownList>
                                <cc1:FilteredTextBoxExtender ID="Fage" runat="Server" FilterType="Numbers,Custom"
                                    TargetControlID="txtAgeFrom" ValidChars=".">
                                </cc1:FilteredTextBoxExtender>
                                <cc1:FilteredTextBoxExtender ID="Tage" runat="server" Enabled="False" FilterType="Numbers,Custom"
                                    TargetControlID="txtAgeTo" ValidChars=".">
                                </cc1:FilteredTextBoxExtender>
                            </div>
                           
                        </div>
                        <div class="row">
                             <div class="col-md-3">
                                <label class="pull-left">
                                    <asp:Label ID="lblroomtype" Text="Room Type " runat="server"></asp:Label>
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:DropDownList ID="cmbRoom" runat="server" Width="" TabIndex="7" ToolTip="Select Room Type" ClientIDMode="Static">
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    <asp:Label ID="lblpanel" Text="Panel " runat="server"></asp:Label>
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:DropDownList ID="cmbCompany" runat="server" Width="" TabIndex="10" ToolTip="Select Panel">
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    <asp:Label ID="lblparentpanel" Text="Parent Panel " runat="server"></asp:Label>
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:DropDownList ID="ddlParentPanel" runat="server" Width="" TabIndex="11"
                                    ToolTip="Select Parent Panel">
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    <asp:Label ID="lblfilestatus" Text="File Status" runat="server"></asp:Label>
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:DropDownList ID="ddlStatus" runat="server" Width="" TabIndex="12" ToolTip="Select File Status">
                                    <asp:ListItem Selected="true" Value="2">Select</asp:ListItem>
                                    <asp:ListItem Value="0">Not Received</asp:ListItem>
                                    <asp:ListItem Value="1">Received</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    <asp:Label ID="lbldischargetype" Text="Discharge Type" runat="server"></asp:Label>
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:DropDownList ID="ddlDischageType" runat="server" Width="" TabIndex="13"
                                    ToolTip="Select Discharge Type" ClientIDMode="Static">
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    <asp:Label ID="lblDoctor" Text="Doctor" runat="server"></asp:Label>
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:DropDownList ID="cmbDoctor" runat="server" Width="" TabIndex="9" ToolTip="Select Doctor">
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    <asp:Label ID="lblfromdate" Text="From Date" runat="server"></asp:Label>
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="ucFromDate" runat="server" TabIndex="14" ClientIDMode="Static" ToolTip="Click To Select From Date"
                                    Width=""></asp:TextBox>
                                <cc1:CalendarExtender ID="Fromdatecal" TargetControlID="ucFromDate" Format="dd-MMM-yyyy"
                                    Animated="true" runat="server">
                                </cc1:CalendarExtender>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    <asp:Label Text="To Date" runat="server" ID="lbltodate"></asp:Label>
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="ucToDate" runat="server" TabIndex="15" ClientIDMode="Static" ToolTip="Click To Select To Date"
                                    Width=""></asp:TextBox>
                                <cc1:CalendarExtender ID="ToDatecal" TargetControlID="ucToDate" Format="dd-MMM-yyyy"
                                    Animated="true" runat="server">
                                </cc1:CalendarExtender>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-1"></div>
                </div>
                <table cellpadding="0" cellspacing="0" style="width: 95%; height: 20px">
                    <tr>
                        <td class="ItDoseLabel" style="width: 15%; height: 21px; text-align: right; display: none;" align="right">
                            <asp:Label ID="lbldepartment" Text="Department :&nbsp;" runat="server"></asp:Label>
                        </td>
                        <td style="width: 35%; height: 21px; text-align: left; display: none;">
                            <asp:DropDownList ID="ddlDepartment" TabIndex="3" ToolTip="Select Department" runat="server"
                                Width="176px">
                            </asp:DropDownList>
                        </td>
                    </tr>
                </table>
            </asp:Panel>
            <asp:Panel ID="pnlopd" runat="server" Style="display: none">
                <div class="row">
                    <div class="col-md-1"></div>
                    <div class="col-md-22">
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    UHID
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtMrnoOpd" runat="server" Width=""></asp:TextBox>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Patient Name
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtPatientnameOpd" runat="server" Width=""></asp:TextBox>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    File Status
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:DropDownList ID="ddlFileStatus_OPD" runat="server"
                                    ToolTip="Select File Status" Width="">
                                    <asp:ListItem Selected="true" Value="2">Select</asp:ListItem>
                                    <asp:ListItem Value="0">IN</asp:ListItem>
                                    <asp:ListItem Value="1">OUT</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    From Date
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="ucFromDateOPD" runat="server" ClientIDMode="Static" ToolTip="Click To Select From Date"
                                    Width=""></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender1" TargetControlID="ucFromDateOPD" Format="dd-MMM-yyyy"
                                    Animated="true" runat="server">
                                </cc1:CalendarExtender>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    To Date
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="ucToDateOPD" runat="server" ClientIDMode="Static" ToolTip="Click To Select To Date"
                                    Width=""></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender2" TargetControlID="ucToDateOPD" Format="dd-MMM-yyyy"
                                    Animated="true" runat="server">
                                </cc1:CalendarExtender>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-1"></div>
                </div>
            </asp:Panel>

        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div style="text-align: center;" class="col-md-24">
                    <asp:RadioButtonList ID="rdblAdDis" runat="server" CssClass="ItDoseLblSpBl" RepeatDirection="Horizontal"
                        Visible="false">
                        <asp:ListItem Value="DI">Discharged</asp:ListItem>
                    </asp:RadioButtonList>
                    <asp:Button ID="btnSearch" runat="server" CssClass="ItDoseButton" TabIndex="16" Text="Search"
                        OnClick="btnSearch_Click1" ToolTip="Click to Search" />
                    <asp:Button ID="btnSave" runat="server" CssClass="ItDoseButton" TabIndex="17" Text="Received"
                        OnClick="btnSave_Click" ToolTip="Click to Received File" />
                    <asp:Button ID="btnReport" runat="server" CssClass="ItDoseButton" TabIndex="18" Text="Export To Excel"
                        OnClick="btnReport_Click" ToolTip="Click to Open Report" />
                </div>
                <div style="text-align: left;">
                    <asp:Label ID="lblColor" BackColor="lightgreen" runat="server" Text="Received" Style="display: none"></asp:Label>
                    <asp:Label ID="lblColor1" BackColor="LightPink" runat="server" Text="Not Received" Style="display: none"></asp:Label>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="Purchaseheader">
                Patient Details Found
            </div>
            <div style="overflow: auto; padding: 3px; width: 100%; height: 274px;">
                <asp:GridView ID="grdPatient" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                    Width="100%" OnRowCommand="grdPatient_RowCommand" OnRowDataBound="grdPatient_RowDataBound">
                    <Columns>
                        <asp:TemplateField HeaderText="Sticker" Visible="false">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemTemplate>
                                <asp:ImageButton ID="imgbtnSticker" ToolTip="Sticker" runat="server" ImageUrl="../../Images/view.GIF"
                                    CausesValidation="false" CommandArgument='<%# Eval("PatientID")%>' CommandName="Sticker" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="View" Visible="false">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemTemplate>
                                <asp:ImageButton ID="imbView" ToolTip="View Details" runat="server" ImageUrl="../../Images/view.GIF"
                                    CausesValidation="false" CommandArgument='<%# Eval("PatientID")+"#"+Eval("TransactionID")+"#"+Eval("RName")%>'
                                    CommandName="View" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField>
                            <HeaderTemplate>
                                <asp:CheckBox ID="chkBoxAll" runat="server" />
                            </HeaderTemplate>
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" Width="30px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" Width="30px" />
                            <ItemTemplate>
                                <asp:CheckBox ID="chkBox" runat="server" />
                                <asp:Label ID="lblIsReceived" runat="server" Visible="false" Text='<%#Eval("MRD_IsFile") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField>
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemTemplate>
                                <a href="../MRD/MRDFolder.aspx?TID=<%# Eval("TransactionID")%>&LoginType=<%#Eval("LoginType")%>&BillNo=<%#Eval("BillNo")%>&Type=<%#Eval("Type") %>&PatientID=<%#Eval("PatientID") %>"
                                    target="iframePatient" onclick="ReseizeIframe(this);" style="border: 0px solid #FFFFFF; display: <%# Util.GetString(Eval("MRD_IsFile")) == "1" ? "":"none" %>;">
                                    <img src="../../Images/Post.gif" style="border: 0px solid #FFFFFF;" /></a>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="S.No.">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemTemplate>
                                <%#Container.DataItemIndex+1%>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="Type" HeaderText="PatientType">
                            <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:TemplateField HeaderText="Summary">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemTemplate>
                                   <asp:ImageButton ID="imgDiscSummary" ToolTip="Click to view Discharge Summary" runat="server" ImageUrl="../../Images/view.GIF"
                                    CausesValidation="false" CommandArgument='<%# Eval("TransactionID")+"#"+Eval("Status") %>' CommandName="DiscSummary" Visible="false" />
                                <asp:Label ID="lblDischargeSummary" runat="server" Visible="false" Text='<%#Eval("DischargeSummary") %>'></asp:Label>
                                </ItemTemplate>
                             </asp:TemplateField>
                        <asp:TemplateField HeaderText="Notes" Visible="false">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemTemplate>
                                 <asp:ImageButton ID="imgDocNotes" ToolTip="Click to view Doctor Notes" runat="server" ImageUrl="../../Images/view.GIF"
                                    CausesValidation="false" CommandArgument='<%# Eval("PatientID")+"#"+Eval("TransactionID")%>' CommandName="DocNotes" Visible="false" />
                                <asp:Label ID="lblDoctorNotes" runat="server" Visible="false" Text='<%#Eval("DoctorNote") %>'></asp:Label>
                                </ItemTemplate>
                             </asp:TemplateField>
                        <asp:BoundField DataField="Register" HeaderText="File Registered">
                            <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="issuestatus" HeaderText="File Status">
                            <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>

                        <asp:TemplateField HeaderText="IPD No.">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemTemplate>
                                <asp:Label ID="lblTransactionID" Text='<%#Util.GetString(Eval("TransNo")) %>'
                                    runat="server"></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="UHID">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemTemplate>
                                <asp:Label ID="lblMRNo" Text='<%#Util.GetString(Eval("PatientID")) %>'
                                    runat="server"></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Name">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemTemplate>
                                <asp:Label ID="lblPName" Text='<%# Eval("PName")%>' runat="server"></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="AgeSex" HeaderText="Age/Sex">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Address" HeaderText="Address">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="AdmitDate" HeaderText="Admit Date & Time">
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="DischargeDate" HeaderText="Discharge Date & Time">
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="StayDays" HeaderText="Stay Days & Time">
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="DischargeType" HeaderText="Discharge Type">
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="DaysAfterDischarge" HeaderText="Day & Time After Discharge">
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="DName" HeaderText="Doctor Name">
                            <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Company_Name" HeaderText="Panel">
                            <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="RName" HeaderText="Room Type">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="RoomName" HeaderText="Room /Bed No.">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="BillingCategory" HeaderText="Billing Category" Visible="false">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="BillStatus" HeaderText="Bill Status">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="SmsStatus" HeaderText="Sms Status" Visible="false">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:TemplateField Visible="false">
                            <ItemStyle CssClass="GridViewLabItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemTemplate>
                                <asp:CheckBox ID="chkBar" runat="server" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="No of Printout" Visible="false">
                            <ItemStyle CssClass="GridViewLabItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemTemplate>
                                <asp:TextBox ID="txtPrintout" Text="0" runat="server" Width="25px"></asp:TextBox>
                           
                                <cc1:FilteredTextBoxExtender ID="Return" runat="server" FilterMode="ValidChars" FilterType="Custom,Numbers"
                                    TargetControlID="txtPrintout">
                                </cc1:FilteredTextBoxExtender>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="BarCodePrint" Visible="false">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemTemplate>
                                <asp:ImageButton ID="imgBarcode" ToolTip="BarCode" runat="server" ImageUrl="../../Images/print.gif"
                                    CausesValidation="false" CommandArgument='<%# Eval("TransactionID")%>' CommandName="BarCode"
                                    Visible="false" />

                                <asp:Image ID="NewImage" runat="server" src="../../Images/print.gif" />
                                <asp:Label ID="lbl1" runat="server" Text='<%# Eval("PName")+","+ Eval("AgeSex")+",a,"+ Util.GetString(Eval("TransactionID")).Replace("ISHHI","")+","+ Util.GetString(Eval("TransactionID")).Replace("ISHHI","")+",29-Feb-12" %>'
                                    Visible="false"></asp:Label>
                                <asp:Label ID="lbl2" runat="server" Text='<%#Util.GetString(Eval("TransactionID")) %>'
                                    Visible="false"></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                </asp:GridView>

                <table id="tbAppointment" style="width: 100%">
                    <tr>
                        <td>
                            <asp:GridView ID="grdMRD" Width="100%" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle">
                                <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                                <Columns>
                                    <asp:TemplateField>
                                        <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        <ItemTemplate>
                                            <a href="../MRD/MRDFolder.aspx?TID=<%# Eval("TransactionID")%>&LoginType=<%#Eval("LoginType")%>&BillNo=<%#Eval("BillNo")%>&Type=<%#Eval("Type")%>&PatientID=<%#Eval("PatientID") %>"
                                                target="iframePatient" onclick="ReseizeIframe1(this);" style="border: 0px solid #FFFFFF;">
                                                <img src="../../Images/Post.gif" style="border: 0px solid #FFFFFF;" /></a>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="S.No">
                                        <ItemTemplate>
                                            <%# Container.DataItemIndex+1 %>
                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewItemStyle" Width="30px" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="Register" HeaderText="File Registered">
                                        <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="issuestatus" HeaderText="File Status">
                                        <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    </asp:BoundField>

                                    <asp:TemplateField HeaderText="UHID" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                        <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                                        <ItemTemplate>
                                            <asp:Label ID="lblMRNo" runat="server" Text='<%#Util.GetString(Eval("PatientID")) %>'></asp:Label>
                                            <asp:Label ID="lblLedgerTnxNo" runat="server" Text='<%#Eval("LedgerTnxNo") %>' Visible="false"></asp:Label>
                                            <asp:Label ID="lblIssueStatus" runat="server" Text='<%#Eval("IsIssue") %>' Visible="false"></asp:Label>
                                            <asp:Label ID="lblReturnStatus" runat="server" Text='<%#Eval("IsReturn") %>' Visible="false"></asp:Label>

                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewItemStyle" Width="120px" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="AppID" Visible="false">
                                        <ItemTemplate>
                                            <asp:Label ID="lblAppID" runat="server" Text='<%#Eval("App_ID") %>'></asp:Label>
                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewItemStyle" Width="30" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="AppNo" HeaderText="App No.">
                                        <ItemStyle CssClass="GridViewItemStyle" Width="60" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    </asp:BoundField>
                                    <asp:TemplateField HeaderText="Patient Name">
                                        <ItemTemplate>
                                            <asp:Label ID="lblPatientName" runat="server" Text='<%#Eval("NAME") %>'></asp:Label>
                                            <asp:Label ID="lblTransactionid" runat="server" Text='<%#Eval("TransactionID") %>' Visible="false"></asp:Label>
                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewItemStyle" Width="220px" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="220px" />
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="DoctorName" HeaderText="Doctor Name">
                                        <ItemStyle CssClass="GridViewItemStyle" Width="100px" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                    </asp:BoundField>
                                    <asp:TemplateField HeaderText="Patient Type">
                                        <ItemTemplate>
                                            <asp:Label ID="lblvisit" runat="server" Text='<%#Eval("VisitType") %>'></asp:Label>
                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewItemStyle" Width="100px" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                    </asp:TemplateField>

                                    <asp:BoundField DataField="AppTime" HeaderText="App Time">
                                        <ItemStyle CssClass="GridViewItemStyle" Width="80px" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="AppDate" HeaderText="App Date">
                                        <ItemStyle CssClass="GridViewItemStyle" Width="80px" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                                    </asp:BoundField>
                                    <asp:TemplateField HeaderText="ConformDate" Visible="false">
                                        <ItemTemplate>
                                            <asp:Label ID="lblConfirmdate" runat="server" Text='<%#Eval("ConformDate") %>'></asp:Label>
                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewItemStyle" Width="220px" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="220px" />
                                    </asp:TemplateField>

                                </Columns>
                            </asp:GridView>
                        </td>
                    </tr>
                </table>
                <asp:GridView ID="grdgeneral" runat="server" AutoGenerateColumns="False" Width="100%" CssClass="GridViewStyle">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField>
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemTemplate>
                                <a href="../MRD/MRDFolder.aspx?TID=<%# Eval("TransactionID")%>&LoginType=<%#Eval("LoginType")%>&BillNo=<%#Eval("BillNo")%>&Type=<%#Eval("Type")%>&PatientID=<%#Eval("PatientID") %>"
                                    target="iframePatient" onclick="ReseizeIframe2(this);" style="border: 0px solid #FFFFFF;">
                                    <img src="../../Images/Post.gif" style="border: 0px solid #FFFFFF;" /></a>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="Register" HeaderText="File Registered">
                            <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="issuestatus" HeaderText="File Status">
                            <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:TemplateField HeaderText="S.No">
                            <ItemTemplate>
                                <%# Container.DataItemIndex+1 %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" Width="30px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="UHID" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                            <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                            <ItemTemplate>
                                <asp:Label ID="lblMRNo" runat="server" Text='<%#Util.GetString(Eval("PatientID")) %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" Width="120px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Patient Name">
                            <ItemTemplate>
                                <asp:Label ID="lblAddress" runat="server" Text='<%#Eval("PName") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" Width="150" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                        <asp:BoundField DataField="Mobile" HeaderText="Contact No.">
                            <ItemStyle CssClass="GridViewItemStyle" Width="60" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Age" HeaderText="Age">
                            <ItemStyle CssClass="GridViewItemStyle" Width="60" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Gender" HeaderText="Sex">
                            <ItemStyle CssClass="GridViewItemStyle" Width="60" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:TemplateField HeaderText="Address">
                            <ItemTemplate>
                                <asp:Label ID="lblAddress" runat="server" Text='<%#Eval("Address") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" Width="200" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Reg. Date">
                            <ItemTemplate>
                                <asp:Label ID="lblRegdate" runat="server" Text='<%#Eval("DateEnrolled") %>'></asp:Label>

                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" Width="100px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                        </asp:TemplateField>

                    </Columns>
                </asp:GridView>
            </div>
        </div>
        <cc1:ModalPopupExtender ID="mpopIssue" runat="server" BackgroundCssClass="filterPupupBackground"
            CancelControlID="btnClose" DropShadow="true" PopupControlID="pnlIssue" PopupDragHandleControlID="dragHandle"
            TargetControlID="btnHidden" BehaviorID="mpopIssue">
        </cc1:ModalPopupExtender>
        <asp:Panel ID="pnlIssue" runat="server" CssClass="pnlOrderItemsFilter" Style="display: none">
            <div id="Div2" runat="server" class="Purchaseheader">
                <b>Issue File </b>&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp;
            &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;
            &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp;
            &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;
            &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; Press
            esc to close
            </div>
            <table cellpadding="0" cellspacing="0" style="width: 712px">
                <tr>
                    <td style="height: 16px;" align="center" colspan="4">
                        <asp:Label ID="lblIssue" runat="server" CssClass="ItDoseLblError"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td style="width: 14%;" align="right">UHID :&nbsp;
                    </td>
                    <td style="width: 29%;" align="left">
                        <asp:Label ID="lblIssuePatientID" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                        <asp:Label ID="lblAppID" runat="server" CssClass="ItDoseLabelSp" Visible="false"></asp:Label>
                    </td>
                    <td style="width: 17%;" align="right">Patient Name :&nbsp;
                    </td>
                    <td style="width: 80%;" align="left">
                        <asp:Label ID="lblIssuePatientName" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                        <asp:Label ID="lblDate" runat="server" Visible="false"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td align="right" style="width: 14%;">Issue Date :&nbsp;
                    </td>
                    <td align="left" style="width: 29%;">
                        <asp:TextBox ID="txtIssueDate" runat="server" TabIndex="1" ToolTip="Select Issue Date"></asp:TextBox>&nbsp;&nbsp;&nbsp;
                    <cc1:CalendarExtender ID="calIssueDate" runat="server" TargetControlID="txtIssueDate"
                        Format="dd-MMM-yyyy">
                    </cc1:CalendarExtender>
                    </td>
                    <td align="right" style="width: 17%;">Issue&nbsp;Remarks :&nbsp;
                    </td>
                    <td align="left" style="width: 38%;">
                        <asp:TextBox ID="txtIssueRemarks" TextMode="MultiLine" Width="207px" Height="30px"
                            runat="server" TabIndex="2" ToolTip="Enter Issue Remarks"></asp:TextBox><asp:Label ID="Label2" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>

                        <asp:RequiredFieldValidator ID="reqIssue" runat="server" ControlToValidate="txtIssueRemarks"
                            Display="None" ErrorMessage="Please Enter Issue Remarks" SetFocusOnError="True"
                            ValidationGroup="Save"></asp:RequiredFieldValidator>
                    </td>
                </tr>
                <tr>
                    <td align="left" style="width: 14%;">

                        <asp:Label ID="lblissueroomno" runat="server" Visible="false"></asp:Label>
                        <asp:Label ID="lblissuerackno" runat="server" Visible="false"></asp:Label>
                        <asp:Label ID="lblissueshelno" runat="server" Visible="false"></asp:Label>

                    </td>
                    <td align="center" colspan="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <asp:Button ID="btnIssueSave" runat="server" CssClass="ItDoseButton"
                        OnClick="btnIssueSave_Click" OnClientClick="return validateIssue();"
                        TabIndex="3" Text="Save" ToolTip="Click to Save" ValidationGroup="Save" />
                        <asp:Button ID="Button1" runat="server" CssClass="ItDoseButton" TabIndex="4"
                            Text="Close" ToolTip="Click to Close" />
                        &nbsp;
                    </td>
                    <td align="left" style="width: 38%;"></td>
                </tr>
            </table>
            <br />
        </asp:Panel>
        <cc1:ModalPopupExtender ID="mpopReturn" runat="server" BackgroundCssClass="filterPupupBackground"
            CancelControlID="btnClose" DropShadow="true" PopupControlID="pnlReturn" PopupDragHandleControlID="dragHandle"
            TargetControlID="btnHidden" BehaviorID="mpopReturn">
        </cc1:ModalPopupExtender>
        <asp:Panel ID="pnlReturn" runat="server" CssClass="pnlOrderItemsFilter" Style="display: none"
            Width="818px">
            <div id="Div3" runat="server" class="Purchaseheader">
                <b>Return File </b>&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; 
            &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Press esc to close
            </div>
            <table cellpadding="0" cellspacing="0" style="width: 816px">
                <tr>
                    <td style="height: 14px;" align="center" colspan="4">
                        <asp:Label ID="lblReturn" runat="server" CssClass="ItDoseLblError"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td align="right" style="width: 7%">Room :&nbsp;</td>
                    <td style="width: 16%">
                        <asp:UpdatePanel ID="UpdtpnlRoom" runat="server">
                            <ContentTemplate>
                                <asp:DropDownList ID="DropDownList1" ToolTip="Select Room" runat="server" Width="151px"
                                    OnSelectedIndexChanged="cmbRoom_SelectedIndexChanged" AutoPostBack="true" TabIndex="1">
                                </asp:DropDownList>
                                <asp:Label ID="Label6" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                                <asp:RequiredFieldValidator ID="reqFileRoom" SetFocusOnError="true" runat="server" ControlToValidate="cmbRoom"
                                    ValidationGroup="SaveFile" InitialValue="0" ErrorMessage="Please Select Room" Display="None"></asp:RequiredFieldValidator>
                            </ContentTemplate>
                            <Triggers>
                                <asp:AsyncPostBackTrigger ControlID="cmbRoom" EventName="SelectedIndexChanged" />
                            </Triggers>
                        </asp:UpdatePanel>
                    </td>
                    <td style="width: 8%" align="right">Rack :&nbsp;</td>
                    <td>
                        <asp:UpdatePanel ID="UpdtpnlAlmirah" runat="server">
                            <ContentTemplate>
                                <asp:DropDownList ID="cmbAlmirah" runat="server" Width="151px" OnSelectedIndexChanged="cmbAlmirah_SelectedIndexChanged"
                                    AutoPostBack="true" ToolTip="Select Rack" TabIndex="2">
                                </asp:DropDownList>
                                <asp:Label ID="Label7" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                                <asp:RequiredFieldValidator ID="reqRack" SetFocusOnError="true" runat="server" ControlToValidate="cmbAlmirah"
                                    ValidationGroup="SaveFile" InitialValue="Select" ErrorMessage="Please Select Rack" Display="None"></asp:RequiredFieldValidator>
                            </ContentTemplate>
                            <Triggers>
                                <asp:AsyncPostBackTrigger ControlID="cmbAlmirah" EventName="SelectedIndexChanged" />
                            </Triggers>
                        </asp:UpdatePanel>
                    </td>
                </tr>
                <tr>
                    <td align="right" style="width: 7%">Shelf :&nbsp;</td>

                    <td style="width: 16%">
                        <asp:UpdatePanel ID="UpdtpnlShelf" runat="server">
                            <ContentTemplate>
                                <asp:DropDownList ID="cmbShelf" runat="server" TabIndex="3" Width="128px" AutoPostBack="true"
                                    OnSelectedIndexChanged="cmbShelf_SelectedIndexChanged" ToolTip="Select Shelf">
                                </asp:DropDownList>

                                <asp:Label ID="Label9" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                                <asp:RequiredFieldValidator ID="reqshelf1" SetFocusOnError="true" runat="server" ControlToValidate="cmbShelf"
                                    ValidationGroup="SaveFile" InitialValue="0" ErrorMessage="Please Select Shelf" Display="None"></asp:RequiredFieldValidator>

                            </ContentTemplate>
                            <Triggers>
                                <asp:AsyncPostBackTrigger ControlID="cmbShelf" EventName="SelectedIndexChanged" />
                            </Triggers>
                        </asp:UpdatePanel>
                    </td>
                    <td style="display: none; text-align: right; width: 8%;">
                        <asp:Label ID="lblFileId" runat="server" Visible="False" Text="Old FileNo. "></asp:Label><asp:Label
                            ID="lblCounter" runat="server" Font-Bold="True"></asp:Label>
                    </td>
                    <td>
                        <asp:DropDownList ID="ddlFileNo" runat="server" Visible="False" Width="140px">
                        </asp:DropDownList>
                        <asp:Label ID="lblFileNo" runat="server" Font-Bold="True" Visible="False"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td style="width: 7%; height: 16px;" align="right">UHID :&nbsp;
                    </td>
                    <td style="width: 16%; height: 16px;" align="left">
                        <asp:Label ID="lblReturnPatientID" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                        <asp:Label ID="lblAppIDReturn" runat="server" CssClass="ItDoseLabelSp" Visible="false"></asp:Label>
                    </td>
                    <td style="width: 8%; height: 16px;" align="right">Patient Name :&nbsp;
                    </td>
                    <td style="width: 20%; height: 16px;" align="left">
                        <asp:Label ID="lblReturnPatientName" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td align="right" style="width: 7%; height: 16px">Return Date :&nbsp;
                    </td>
                    <td align="left" style="width: 16%; height: 16px">
                        <asp:TextBox ID="txtReturnDate" runat="server" TabIndex="1" ToolTip="Select Return Date"></asp:TextBox>&nbsp;&nbsp;&nbsp;
                    <cc1:CalendarExtender ID="calReturn" runat="server" TargetControlID="txtReturnDate"
                        Format="dd-MMM-yyyy">
                    </cc1:CalendarExtender>
                    </td>
                    <td align="right" style="width: 8%; height: 16px">Return&nbsp;Remarks :&nbsp;
                    </td>
                    <td align="left" style="width: 20%; height: 16px">
                        <asp:TextBox ID="txtReturnRemarks" TabIndex="2" ToolTip="Enter Return Remarks" TextMode="MultiLine"
                            runat="server" Width="240px" Height="44px"></asp:TextBox><asp:Label ID="Label3" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                        <asp:RequiredFieldValidator ID="reqReturn" runat="server" ControlToValidate="txtReturnRemarks"
                            Display="None" ErrorMessage="Please Enter Return Remarks" SetFocusOnError="True"
                            ValidationGroup="Save"></asp:RequiredFieldValidator>
                    </td>
                </tr>
                <tr>
                    <td align="left" style="width: 7%; height: 16px">
                        <asp:Label ID="lbltran" runat="server" Visible="false"></asp:Label>
                        <asp:Label ID="lblvisittype" runat="server" Visible="false"></asp:Label>
                    </td>
                    <td align="center" colspan="2" style="height: 16px">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <asp:Button ID="btnReturnSave" runat="server" CssClass="ItDoseButton"
                        OnClick="btnReturnSave_Click" OnClientClick="return validateReturn();"
                        TabIndex="3" Text="Save" ToolTip="Click to Save" ValidationGroup="Save" />
                        <asp:Button ID="btnReturnCancel" runat="server" CssClass="ItDoseButton"
                            Text="Close" ToolTip="Click to Close" />
                        &nbsp;
                    </td>
                    <td align="left" style="width: 20%; height: 16px"></td>
                </tr>
            </table>
            <br />
        </asp:Panel>
        <div style="display: none;">
            <asp:Button ID="Button2" runat="server" Text="Button" CssClass="ItDoseButton" />
        </div>
        <asp:Panel ID="Panel2" runat="server" CssClass="pnlItemsFilter" Style="display: none"
            ScrollBars="Auto" Width="600px">
            <div>
                <div id="Div4" runat="server" class="Purchaseheader">
                    File Status
                </div>
                <table style="width: 99%">
                    <tr>
                        <td style="width: 131px; text-align: right">File Issue Date :&nbsp;</td>
                        <td style="width: 98px; text-align: left">
                            <asp:Label ID="lblIssueDate" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                        </td>
                        <td style="text-align: right; width: 131px;">Issue Remarks :&nbsp;
                        </td>
                        <td style="text-align: left">
                            <asp:Label ID="lblIssueRemarks" runat="server" CssClass="ItDoseLabelSp"></asp:Label>

                        </td>
                    </tr>
                    <tr>
                        <td style="width: 131px; text-align: right">File Return date :&nbsp;</td>
                        <td style="width: 98px; text-align: left">
                            <asp:Label ID="lblReturnDate" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                        </td>
                        <td style="text-align: right; width: 131px;">Return Remarks :&nbsp;
                        </td>
                        <td style="text-align: left">
                            <asp:Label ID="lblReturnRemarks" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 131px; text-align: right">
                            <asp:Label ID="Label1" runat="server" Text="Room Name :"></asp:Label>&nbsp;</td>
                        <td style="width: 98px; text-align: left">
                            <asp:Label ID="lblRoomno" runat="server" CssClass="ItDoseLabelSp"></asp:Label></td>
                        <td style="text-align: right; width: 131px;">
                            <asp:Label ID="lblRack" runat="server" Text="Rack Name :"></asp:Label>&nbsp;
                        </td>
                        <td style="text-align: left">
                            <asp:Label ID="lblRackno" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 131px; text-align: right">
                            <asp:Label ID="lblshelf" runat="server" Text="Shelf No. :"></asp:Label>&nbsp;</td>
                        <td style="width: 98px; text-align: left">
                            <asp:Label ID="lblShelfNo" runat="server" CssClass="ItDoseLabelSp"></asp:Label></td>
                        <td style="text-align: right; width: 131px;">&nbsp;
                        </td>
                        <td style="text-align: left">&nbsp;</td>
                    </tr>
                    <tr>
                        <td></td>
                        <td style="width: 30px"></td>
                        <td style="text-align: center; width: 131px;">
                            <asp:Button ID="btnCancel1" runat="server" Text="Close" CssClass="ItDoseButton" />
                        </td>
                    </tr>
                </table>
            </div>
        </asp:Panel>
        <cc1:ModalPopupExtender ID="mpe2" runat="server" DropShadow="true" BackgroundCssClass="filterPupupBackground"
            PopupDragHandleControlID="dragHandle" CancelControlID="btnCancel1" PopupControlID="Panel2"
            TargetControlID="btn2" X="80" Y="100">
        </cc1:ModalPopupExtender>
        <div style="display: none;">
            <asp:Button ID="btn2" runat="server" />
        </div>
        <asp:Panel ID="Panel1" runat="server" BackColor="#EAF3FD" BorderStyle="None" Style="display: none;">
            <div class="POuter_Box_Inventory" style="width: 800px;">
                <div class="content">
                    <div style="text-align: center;">
                        <div class="POuter_Box_Inventory" style="width: 780px; text-align: center;">
                            <div id="Div1" class="Purchaseheader" style="text-align: center">
                                Patient IPD Information
                            </div>
                            <table border="0" cellpadding="0" cellspacing="0" width="760">
                                <tr>
                                    <td align="left" style="height: 16px" valign="middle" width="170">&nbsp;PatientName
                                    </td>
                                    <td align="left" class="general4" style="height: 16px" valign="middle" width="227">&nbsp;<asp:Label ID="lblPName" runat="server"></asp:Label>
                                    </td>
                                    <td align="left" class="general3" style="height: 16px" valign="middle" width="182">Address
                                    </td>
                                    <td align="left" style="height: 16px" valign="middle" width="201">&nbsp;<asp:Label ID="lblAddress" runat="server" CssClass="general4" Width="195px"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" style="height: 16px" valign="middle">&nbsp;Age
                                    </td>
                                    <td align="left" style="height: 16px" valign="middle">&nbsp;<asp:Label ID="lblAge" runat="server" CssClass="general4"></asp:Label>
                                    </td>
                                    <td align="left" class="general3" style="height: 16px" valign="middle">Gender
                                    </td>
                                    <td align="left" style="height: 16px" valign="middle">&nbsp;<asp:Label ID="lblGender" runat="server" CssClass="general4"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" style="height: 15px" valign="middle">&nbsp;CaseType
                                    </td>
                                    <td align="left" style="height: 15px" valign="middle">&nbsp;<asp:Label ID="lblCase" runat="server" CssClass="general4"></asp:Label>
                                    </td>
                                    <td align="left" class="general3" style="height: 15px" valign="middle">RoomNo
                                    </td>
                                    <td align="left" style="height: 15px" valign="middle">&nbsp;<asp:Label ID="lblRoom" runat="server" CssClass="general4"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" style="height: 16px" valign="middle">&nbsp;Admit Date
                                    </td>
                                    <td align="left" style="height: 16px" valign="middle">&nbsp;<asp:Label ID="lblAdmitDate" runat="server" CssClass="general4"></asp:Label>
                                    </td>
                                    <td align="left" class="general3" style="height: 16px" valign="middle">Discharge Date
                                    </td>
                                    <td align="left" style="height: 16px" valign="middle">&nbsp;<asp:Label ID="lblDisDate" runat="server" CssClass="general4"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" style="height: 16px" valign="middle">&nbsp;Phone No
                                    </td>
                                    <td align="left" style="height: 16px" valign="middle">
                                        <asp:Label ID="lblPhone" runat="server" CssClass="general4"></asp:Label>
                                    </td>
                                    <td align="left" class="general3" style="height: 16px" valign="middle">Mobile no
                                    </td>
                                    <td align="left" style="height: 16px" valign="middle">
                                        <asp:Label ID="lblMobile" runat="server" CssClass="general4"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" valign="middle">&nbsp;KinRelation
                                    </td>
                                    <td align="left" valign="middle">&nbsp;<asp:Label ID="lblKinRelation" runat="server" CssClass="general4"></asp:Label>
                                    </td>
                                    <td align="left" class="general3" valign="middle">Kin Name
                                    </td>
                                    <td align="left" valign="middle">&nbsp;<asp:Label ID="lblKinName" runat="server" CssClass="general4"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" valign="middle"></td>
                                    <td align="left" valign="middle"></td>
                                    <td align="left" class="general3" valign="middle"></td>
                                    <td align="left" valign="middle"></td>
                                </tr>
                                <tr>
                                    <td align="left" colspan="4" style="text-align: center" valign="middle">
                                        <asp:Button ID="btnClose" runat="server" CssClass="ItDoseButton" Text="Close" />
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" colspan="4" style="text-align: center" valign="middle">&nbsp;
                                    </td>
                                </tr>
                            </table>
                        </div>
                        &nbsp;&nbsp;
                    </div>
                </div>
            </div>
        </asp:Panel>
        <cc1:ModalPopupExtender ID="mdlPatient" runat="server" CancelControlID="btnClose"
            TargetControlID="btnHidden" BackgroundCssClass="filterPupupBackground" PopupControlID="Panel1"
            X="100" Y="80">
        </cc1:ModalPopupExtender>
        <div style="display: none;">
            <asp:Button ID="btnHidden" runat="server" Text="Button" />
        </div>
        <iframe id="iframePatient" name="iframePatient" src="" style="position: fixed; top: 32px; left: 0px; background-color: #FFFFFF; display: none;" frameborder="0" enableviewstate="true"></iframe>
    </div>
</asp:Content>
