<%@ Page Language="C#" EnableEventValidation="false" AutoEventWireup="true" CodeFile="SurgeryIPD.aspx.cs"
    Inherits="Design_IPD_SurgeryIPD" MaintainScrollPositionOnPostback="true" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Untitled Page</title>
    <link href="../../Styles/framestyle.css" rel="stylesheet" type="text/css" />
    <link href="../../Styles/CustomStyle.css" rel="stylesheet" />
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="../../Styles/easyui.css" />
    <link rel="Stylesheet" type="text/css" href="../../Scripts/chosen.css" />
    <script type="text/javascript" src="../../Scripts/jquery-1.7.1.min.js"></script>
    <script type="text/javascript" src="../../Scripts/Common.js"></script>
    <script src="../../Scripts/jquery.extensions.js" type="text/javascript"></script>
    <script src="../../Scripts/json2.js" type="text/javascript"></script>
    <script type="text/javascript" src="../../Scripts/chosen.jquery.js"></script>
    <script type="text/javascript" src="../../Scripts/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">
        function closechildwindow() {
            window.close();
        }


        function saveMessage() {
            modelAlert('Record Save Successfully', function () {
                window.location = window.location;
            });
        }
        function CheckAllItem(Checkbox) {
            var flag = true;
            if ($("[id$=chkAll]").is(':checked') == true)
                $("[id$=ChkSelect]").attr('checked', true);
            else {
                $("[id$=ChkSelect]").attr('checked', false);
            }
        }
    </script>
    <script type="text/javascript">
        function CheckDocCharge() {
            if (document.getElementById('txtChargesPer').value == '' && document.getElementById('txtChargeAmt').value == '') {
                alert('Specify Doctor Charges');
                return false;
            }
            else
                return true;
        }
        function ClickSelectbtn(e, btnName) {
            if (window.event.keyCode == 13) {
                var btn = document.getElementById(btnName);
                alert(btn);
                if (btn != null) { //If we find the button click it
                    btn.click();
                    event.keyCode = 0
                    return false;
                }
            }
        }
    </script>
</head>
<body>
    <script type="text/javascript">
        var keys = [];
        var values = [];

        function checkForSecondDecimal(sender, e) {
            formatBox = document.getElementById(sender.id);
            strLen = sender.value.length;
            strVal = sender.value;
            hasDec = false;
            e = (e) ? e : (window.event) ? event : null;


            if (e) {
                var charCode = (e.charCode) ? e.charCode :
                            ((e.keyCode) ? e.keyCode :
                            ((e.which) ? e.which : 0));


                if ((charCode == 46) || (charCode == 110) || (charCode == 190)) {
                    for (var i = 0; i < strLen; i++) {
                        hasDec = (strVal.charAt(i) == '.');
                        if (hasDec)
                            return false;
                    }
                }
            }
            return true;
        }

        $(document).ready(function () {

            CheckStatus();
            $("input[id*=txtDiscAmt]").bind("keyup keydown", function () {
                var DigitsAfterDecimal = 2;
                var val = ($(this).closest("tr").find("input[id*=txtDiscAmt]").val());
                var valIndex = val.indexOf(".");
                if (valIndex > "0") {
                    if (val.length - (val.indexOf(".") + 1) > DigitsAfterDecimal) {
                        alert("Please Enter Valid Discount Amount, Only " + DigitsAfterDecimal + " Digits Are Allowed After Decimal");
                        $(this).closest("tr").find("input[id*=txtDiscAmt]").val($(this).closest("tr").find("input[id*=txtDiscAmt]").val().substring(0, ($(this).closest("tr").find("input[id*=txtDiscAmt]").val().length - 1)))
                        return false;
                    }
                }
                if ($(this).closest("tr").find("input[id*=txtDiscAmt]").val() > 0) {
                    $(this).closest("tr").find("input[id*=txtDiscPer]").val('0');
                }
                if ((parseFloat($(this).closest("tr").find("input[id*=txtDiscAmt]").val())) > ($(this).closest("tr").find("span[id*=lblNetAmt]").text())) {
                    alert("Discount Amount Can Not Greater then Net Amount");
                    $(this).closest("tr").find("input[id*=txtDiscAmt]").val($(this).closest("tr").find("input[id*=txtDiscAmt]").val().substring(0, ($(this).closest("tr").find("input[id*=txtDiscAmt]").val().length - 1)))
                    return false;
                }
            });
            $("input[id*=txtDiscPer]").bind("keyup keydown", function () {
                var DigitsAfterDecimal = 6;
                var val = ($(this).closest("tr").find("input[id*=txtDiscPer]").val());
                var valIndex = val.indexOf(".");
                if (valIndex > "0") {
                    if (val.length - (val.indexOf(".") + 1) > DigitsAfterDecimal) {
                        alert("Please Enter Valid Discount Percent, Only " + DigitsAfterDecimal + " Digits Are Allowed After Decimal");
                        $(this).closest("tr").find("input[id*=txtDiscPer]").val($(this).closest("tr").find("input[id*=txtDiscPer]").val().substring(0, ($(this).closest("tr").find("input[id*=txtDiscPer]").val().length - 1)))
                        return false;
                    }
                }
                if ($(this).closest("tr").find("input[id*=txtDiscPer]").val() > 100) {
                    alert("Please Enter Valid Discount Percent");
                    $(this).closest("tr").find("input[id*=txtDiscPer]").val($(this).closest("tr").find("input[id*=txtDiscPer]").val().substring(0, ($(this).closest("tr").find("input[id*=txtDiscPer]").val().length - 1)))
                }
                if ($(this).closest("tr").find("input[id*=txtDiscPer]").val() > 0) {
                    $(this).closest("tr").find("input[id*=txtDiscAmt]").val('0');
                }
            });
        });
        function validateSurgery() {
            $("#gvItem input[name*='txtDiscPer']").each(function (index) {
                if ($.trim($(this).val()) > 0.00) {

                    $("#<%=lblMsg.ClientID %>").text('Please Select Approval');
                    $("#<%=ddlApproveBy.ClientID %>").focus();
                    return false;
                }

            });
            $("#gvItem input[name*='txtDiscAmt']").each(function (index) {
                if ($.trim($(this).val()) > 0) {
                    $("#<%=lblMsg.ClientID %>").text('Please Select Approval');
                    $("#<%=ddlApproveBy.ClientID %>").focus();
                    return false;
                }
            });

            document.getElementById('<%=btnSave.ClientID%>').disabled = true;
            document.getElementById('<%=btnSave.ClientID%>').value = 'Submitting...';
            __doPostBack('btnSave', '');
        }
        var Ok;
        function ConfirmSave(EntryDt, Name) {
            Ok = confirm('This Surgery is Already Prescribed By ' + Name + ' Date On ' + EntryDt + '. Do You Want To Prescribe Again ???');
            if (Ok) {
                var btn = document.getElementById("<%=btnAddDirect.ClientID %>");
                btn.click();
            }
            else {
                var btnCancel = document.getElementById("<%=Button2.ClientID %>");
                btnCancel.click();
            }


        }
        function CheckStatus() {
            $("#<%=gvItem.ClientID%> input[id*='chkSelect']:checkbox").each(function () {
                if ($(this).is(':checked')) {
                    $(this).closest("tr").find('#ddlDoctor,#txtCharges,#txtchargesAmt').removeAttr('disabled');
                    var isPanelWiseDiscount = Number($(this).closest('tr').find('#lblIsPanelWiseDiscount').text());
                    if (isPanelWiseDiscount == 0)
                        $(this).closest("tr").find('#txtDiscPer,#txtDiscAmt').removeAttr('disabled');

                    $(this).closest("tr").find('#ddlDoctor').chosen("destroy").chosen();
                }
                else {
                    $(this).closest("tr").find('#ddlDoctor').chosen("destroy");
                    $(this).closest("tr").find('#ddlDoctor,#txtCharges,#txtchargesAmt,#txtDiscPer,#txtDiscAmt').attr('disabled', 'disabled');
                }
            });
        }
    </script>
    <script type="text/javascript">
        function ValidateCharactercount(charlimit, cont) {
            var id = "#" + cont.id;
            if ($(id).text().length > charlimit) {
                $(id).text($(id).text().substring(0, charlimit));
                //            $("#divmessage").html("Maximum cahracter allowes :" + charlimit);
            }
        }
    </script>
    <script type="text/javascript">
        function validate() {
            $("input[id*=txtDocCharges]").val('');

            var DigitsAfterDecimal = 2;
            var val = $("input[id*=txtSurgeryAmt]").val();
            var valIndex = val.indexOf(".");
            if (valIndex > "0") {
                if (val.length - (val.indexOf(".") + 1) > DigitsAfterDecimal) {
                    alert("Please Enter Valid Rate, Only " + DigitsAfterDecimal + " Digits Are Allowed After Decimal");
                    $("input[id*=txtSurgeryAmt]").val($("input[id*=txtSurgeryAmt]").val().substring(0, ($("input[id*=txtSurgeryAmt]").val().length - 1)));
                    total1 = $("input[id*=txtSurgeryAmt]").val();
                }
            }
        }
        function validates() {
            $("input[id*=txtSurgeryAmt]").val('');
            var DigitsAfterDecimal = 2;
            var val = $("input[id*=txtDocCharges]").val();
            var valIndex = val.indexOf(".");
            if (valIndex > "0") {
                if (val.length - (val.indexOf(".") + 1) > DigitsAfterDecimal) {
                    alert("Please Enter Valid Rate, Only " + DigitsAfterDecimal + " Digits Are Allowed After Decimal");
                    $("input[id*=txtDocCharges]").val($("input[id*=txtDocCharges]").val().substring(0, ($("input[id*=txtDocCharges]").val().length - 1)));
                    total1 = $("input[id*=txtDocCharges]").val();
                }
            }
        }
        function checkForSecond(sender, e) {
            formatBox = document.getElementById(sender.id);
            strLen = sender.value.length;
            strVal = sender.value;
            hasDec = false;
            e = (e) ? e : (window.event) ? event : null;


            if (e) {
                var charCode = (e.charCode) ? e.charCode :
                            ((e.keyCode) ? e.keyCode :
                            ((e.which) ? e.which : 0));
                if ((charCode == 46)) {
                    for (var i = 0; i < strLen; i++) {
                        hasDec = (strVal.charAt(i) == '.');
                        if (hasDec)
                            return false;
                    }
                }
            }
            return true;
        }
    </script>
    <script type="text/javascript">
        $(document).ready(function () {
            if ($.browser.msie)
                $("#<%=ucSurDate.ClientID%>").keydown(function (e) {
                    if (e.keyCode === 8) window.event.keyCode = 0;
                });
        });
    </script>
    <script type="text/javascript">

        function calculateSurgery() {
            document.getElementById('<%=btnCalculator.ClientID%>').disabled = true;
            document.getElementById('<%=btnCalculator.ClientID%>').value = 'Calculating...';
            __doPostBack('btnCalculator', '');
        }
        function clickSearchButton() {
            alert('Record Saved Successfully');
            opener.document.getElementById("btnSearch").click();

            this.focus();
            self.opener = this;
            self.close();

        }
    </script>
    <script type="text/javascript">


        var getSelected = function (e) {
            e.preventDefault();
            var txtMedicineSearch = $('#cmbItem');
            var grid = txtMedicineSearch.combogrid('grid');
            var selectedRow = grid.datagrid('getSelected');
            var code = (e.keyCode ? e.keyCode : e.which);
            if (String.isNullOrEmpty(selectedRow)) {
                modelAlert('Please Select Item First', function () {
                    $('.textbox-text.validatebox-text').focus();
                    txtMedicineSearch.combogrid('reset');
                });
                return;
            }
            var ItemID = $.trim(selectedRow.ItemId);
            $('#txtSurgeryID').val(ItemID);
            $('#lblSurgeryName').text($.trim(selectedRow.TypeName));
            $('#txtSurgeryName').val($.trim(selectedRow.TypeName));
            $('#lblDept').text($.trim(selectedRow.Department));
            $('#lblCode').text($.trim(selectedRow.SurgeryCode));
            __doPostBack('btnRate', '');
        }


    </script>
    <form id="form1" runat="server">
        <div id="Pbody_box_inventory">
            <Ajax:ScriptManager ID="sm1" runat="server" />
            <div class="POuter_Box_Inventory" style="text-align: center;">

                <b>Surgery Detail</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
                <span id="spnErrorMsg" class="ItDoseLblError"></span>
                <span id="spnPanelID" runat="server" clientidmode="Static" style="display: none"></span>
                <span id="spnTransactionID" runat="server" clientidmode="Static" style="display: none"></span>
                <span id="spnPatientID" runat="server" clientidmode="Static" style="display: none"></span>
                <span id="spnRoom_ID" runat="server" clientidmode="Static" style="display: none"></span>
                <span id="spnIPD_CaseTypeID" runat="server" clientidmode="Static" style="display: none"></span>
                <span id="spnReferenceCodeIPD" runat="server" clientidmode="Static" style="display: none"></span>
                <span id="spnPatientType" runat="server" clientidmode="Static" style="display: none"></span>
                <span id="spnScheduleChargeID" runat="server" clientidmode="Static" style="display: none"></span>
                <span id="spnPatientTypeID" runat="server" clientidmode="Static" style="display: none"></span>
            </div>
            <div class="POuter_Box_Inventory">

                <div class="row">
                    <div class="col-md-24">
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">Date</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="ucSurDate" runat="server" ToolTip="Click to Select Date"></asp:TextBox>
                                <cc1:CalendarExtender ID="calucDate" runat="server" TargetControlID="ucSurDate" Format="dd-MMM-yyyy">
                                </cc1:CalendarExtender>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Rate On</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:RadioButtonList ID="rdoRateType" runat="server" RepeatDirection="Horizontal" RepeatLayout="Table" RepeatColumns="2">
                                    <asp:ListItem Value="1" Text="Surgery" ></asp:ListItem>
                                    <asp:ListItem Value="2" Text="Surgeon" Selected="True"></asp:ListItem>
                                </asp:RadioButtonList>
                            </div>

                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">Search By Name</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-8">
                                <input id="cmbItem" tabindex="3" class="easyui-combogrid" style="width: 250px; height: 20px" data-options="
			panelWidth: 600,
			idField: 'ItemId',
			textField: 'TypeName',
            mode:'remote',                                       
			url: 'SearchSurgeryIPD.aspx?cmd=item',
            loadMsg: 'Serching... ',
			method: 'get',
            pagination:true,
            rownumbers:true,
            pageSize: 10,                                                  
            fit:true,
            border:false,   
            cache:false,  
            nowrap:true,                                                   
            emptyrecords: 'No records to display.',
            mode:'remote',
            onHidePanel: function(){ },
            onBeforeLoad: function (param) {
                   var TransactionID= $('#spnTransactionID').text();
                   var ReferenceCode = $('#spnReferenceCodeIPD').text();
                   var IPDCaseTypeID =$('#spnIPD_CaseTypeID').text();
                   var ScheduleChargeID = $('#spnScheduleChargeID').text();
                   param.TransactionID = TransactionID;
                   param.ReferenceCode = ReferenceCode;
                   param.IPDCaseTypeID = IPDCaseTypeID;
                   param.ScheduleChargeID = ScheduleChargeID;
                                    },
			columns: [[
                {field:'Department',title:'Department',width:200,align:'center'},
                {field:'SurgeryCode',title:'CPT Code',width:100,align:'center'},
				{field:'TypeName',title:'Surgery Name',width:400,align:'center'},
        		{field:'SurgeonCharge',title:'Rate',width:100,align:'center'}
			]],
			fitColumns: true
		" />
                            </div>
                            <div class="col-md-3">
                                <asp:Button ID="btnRate" runat="server" Text="Get Rate" CssClass="ItDoseButton" OnClientClick="getSelected(event)" OnClick="btnRate_Click" />
                                <asp:Button ID="btnAddItem" runat="server" Text="Add Item" CssClass="ItDoseButton"
                                    Visible="False" /><br />
                            </div>
                            <div class="col-md-3">
                                <asp:Button ID="btn_set" runat="server" Text="Reset" CssClass="ItDoseButton" OnClick="btn_set_Click" />
                            </div>
                            <div class="col-md-7">
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">Selected Surg.</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:Label ID="lblSurgeryName" runat="server" ClientIDMode="Static" CssClass="patientInfo"></asp:Label>
                                <asp:TextBox ID="txtSurgeryID" runat="server" ClientIDMode="Static" Style="display: none;"></asp:TextBox>
                                <asp:TextBox ID="txtSurgeryName" runat="server" ClientIDMode="Static" Style="display: none;"></asp:TextBox>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Department</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:Label ID="lblDept" runat="server" ClientIDMode="Static" CssClass="patientInfo"></asp:Label>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">CPT Code</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:Label ID="lblCode" runat="server" ClientIDMode="Static" CssClass="patientInfo"></asp:Label><asp:TextBox ID="txttotal" runat="server" Text="0" Visible="false"></asp:TextBox>
                            </div>

                        </div>
                        <asp:GridView ID="gvSurgeryDetail" CssClass="GridViewStyle" runat="server" OnRowDataBound="gvSurgeryDetail_RowDataBound" AutoGenerateColumns="false" Width="950px" OnRowDeleting="gvSurgeryDetail_RowDeleting" ShowFooter="True">
                            <Columns>
                                <asp:TemplateField HeaderText="#" Visible="false">
                                    <ItemTemplate>
                                        <asp:CheckBox ID="chkSelect" runat="server" Checked='<%# Util.GetBoolean(Eval("IsSelected")) %>' ClientIDMode="Static" />
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="35px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="S.No.">
                                    <ItemTemplate>
                                        <%#Container.DataItemIndex+1 %>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="35px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Code">
                                    <ItemTemplate>
                                        <asp:Label ID="lblSurgeryCode" runat="server" Text='<%#Eval("SurgeryCode") %>' />
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="SurgeryID" Visible="false">
                                    <ItemTemplate>
                                        <asp:Label ID="lblSurgeryID" runat="server" Text='<%#Eval("SurgeryID") %>' />
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Surgery Name">
                                    <ItemTemplate>
                                        <asp:Label ID="lblSurgeryName" runat="server" Text='<%#Eval("SurgeryName") %>' />
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="250px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Department" Visible="false">
                                    <ItemTemplate>
                                        <asp:Label ID="lblDepartment" runat="server" Text='<%#Eval("Department") %>' />
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="180px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Remark">
                                    <ItemTemplate>
                                        <asp:TextBox ID="txtRemark" runat="server" Text='<%#Eval("Remark") %>' Style="width: 200px;" />
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="180px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Rate" SortExpression="Rate">
                                    <ItemTemplate>
                                        <asp:TextBox ID="txtRate" runat="server" Text='<%#Eval("Rate") %>' Width="70px"></asp:TextBox>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="70px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Reduce (%)">
                                    <ItemTemplate>
                                        <asp:TextBox ID="txtReducePerOn" runat="server" Text='<%#Eval("ReducePerOn") %>' Visible="false" Width="50px"></asp:TextBox>
                                        <asp:TextBox ID="txtCalReducePerOn" runat="server" Text='<%#Eval("CalReducePerOn") %>' Width="50px"></asp:TextBox>
                                        <cc1:FilteredTextBoxExtender ID="fl2" runat="server" TargetControlID="txtCalReducePerOn"
                                            FilterType="Numbers,Custom" ValidChars="." />
                                    </ItemTemplate>
                                    <FooterTemplate>
                                        <asp:Button ID="BtnCalSurgery" runat="server" Text="Calculate" CssClass="ItDoseButton" OnClick="BtnCalSurgery_Click" />
                                    </FooterTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="90px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="New Rate">
                                    <ItemTemplate>
                                        <asp:TextBox ID="txtNewRate" runat="server" Text='<%#Eval("NewRate") %>' Width="50px"></asp:TextBox>
                                    </ItemTemplate>
                                    <FooterTemplate>
                                        <asp:Label ID="lblTotal" runat="server" />
                                    </FooterTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="70px" />
                                </asp:TemplateField>
                                <asp:CommandField HeaderStyle-Width="20px" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderText="" HeaderStyle-CssClass="GridViewHeaderStyle" ButtonType="Image"
                                    DeleteText="Delete Item" ShowDeleteButton="true" DeleteImageUrl="~/Images/Delete.gif"
                                    ItemStyle-HorizontalAlign="Center">
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="20px"></HeaderStyle>
                                    <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle"></ItemStyle>
                                </asp:CommandField>
                            </Columns>
                            <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                        </asp:GridView>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">Calculate On</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:RadioButtonList ID="rdoSurgeryCalculate" runat="server" RepeatDirection="Horizontal" RepeatLayout="Table" RepeatColumns="2" AutoPostBack="true" OnSelectedIndexChanged="rdoSurgeryCalculate_SelectedIndexChanged">
                                    <asp:ListItem Value="1" Text="Amount"></asp:ListItem>
                                    <asp:ListItem Value="2" Text="%age" Selected="True"></asp:ListItem>
                                </asp:RadioButtonList>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Surgery Amt</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtSurgeryAmt" runat="server" CssClass="ItDoseTextinputNum" MaxLength="10" onkeyup="validate();" onkeypress="return checkForSecond(this,event)" AutoCompleteType="Disabled" />
                                <cc1:FilteredTextBoxExtender ID="fttxtBp" runat="server" TargetControlID="txtSurgeryAmt"
                                    ValidChars="0987654321.">
                                </cc1:FilteredTextBoxExtender>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Surgeon Amt</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtDocShared" runat="server" CssClass="ItDoseTextinputNum" Width="76px"
                                    Style="display: none" />
                                <asp:TextBox ID="txtDocCharges" runat="server" CssClass="ItDoseTextinputNum" MaxLength="10" onkeyup="validates();" onkeypress="return checkForSecond(this,event)" AutoCompleteType="Disabled" />
                                <cc1:FilteredTextBoxExtender ID="fl5" runat="server" TargetControlID="txtDocCharges"
                                    FilterType="Numbers,Custom" ValidChars="." />
                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender5" runat="server" TargetControlID="txtDocCharges"
                                    ValidChars="0987654321.">
                                </cc1:FilteredTextBoxExtender>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Surgery Details
                </div>

                <asp:GridView ID="gvItem" CssClass="GridViewStyle" runat="server" AutoGenerateColumns="false"
                    OnRowCommand="gvItem_RowCommand" OnRowDataBound="gvItem_RowDataBound" Width="100%">
                    <Columns>
                        <asp:TemplateField HeaderText="#">
                            <ItemTemplate>
                                <asp:CheckBox ID="chkSelect" runat="server" Checked='<%# Util.GetBoolean(Eval("IsSelected")) %>' ClientIDMode="Static" onclick="CheckStatus()" />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="35px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="S.No.">
                            <ItemTemplate>
                                <%#Container.DataItemIndex+1 %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="35px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Type">
                            <ItemTemplate>
                                <asp:Label ID="lblItemType" runat="server" Text='<%#Eval("Type") %>' />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="180px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Doctor">
                            <ItemTemplate>
                                <asp:DropDownList ID="ddlDoctor" Width="250px" CssClass="requiredField" runat="server" ClientIDMode="Static">
                                </asp:DropDownList>
                                <asp:Label ID="lblDoctor" runat="server" Text="  -  "></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="250px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Charges %" Visible="true">
                            <ItemTemplate>
                                <asp:TextBox ID="txtCharges" runat="server" Width="75px" CssClass="ItDoseTextinputNum" ClientIDMode="Static"
                                    Text='<%#Eval("DoctorChargePer","{0:f2}") %>'></asp:TextBox>

                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="84px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Charge Amt." Visible="true">
                            <ItemTemplate>
                                <asp:TextBox ID="txtchargesAmt" runat="server" Width="75px" CssClass="ItDoseTextinputNum" AutoCompleteType="Disabled"
                                    ClientIDMode="Static" Text='<%#Eval("DoctorCharge","{0:f2}") %>'></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="fl2" runat="server" TargetControlID="txtchargesAmt"
                                    FilterType="Numbers,Custom" ValidChars="." />

                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="75px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Disc. %">
                            <ItemTemplate>
                                <asp:TextBox ID="txtDiscPer" runat="server" Width="75px" CssClass="ItDoseTextinputNum"
                                    ClientIDMode="Static" Text='<%#Eval("DiscountPer","{0:f2}") %>' onkeypress="return checkForSecondDecimal(this,event)"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="fl3" runat="server" TargetControlID="txtDiscPer"
                                    FilterType="Numbers,Custom" ValidChars="." />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="75px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Disc. Amt.">
                            <ItemTemplate>
                                <asp:Label ID="lblIsPanelWiseDiscount" ClientIDMode="Static" Text='<%#Eval("IsPanelWiseDiscount") %>' runat="server" Style="display: none"></asp:Label>
                                <asp:TextBox ID="txtDiscAmt" runat="server" Width="75px" CssClass="ItDoseTextinputNum"
                                    ClientIDMode="Static" Text='<%#Eval("DiscountAmt","{0:f2}") %>' onkeypress="return checkForSecondDecimal(this,event)"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="fl4" runat="server" TargetControlID="txtDiscAmt"
                                    FilterType="Numbers,Custom" ValidChars="." />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="75px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Net Amt.">
                            <ItemTemplate>
                                <asp:Label ID="lblNetAmt" runat="server" Width="75px" CssClass="ItDoseTextinputNum" Text='<%#Eval("NetAmt","{0:f2}") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="75px" />
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Panel Non-Payable">
                            <ItemTemplate>
                                <asp:Label ID="lblNonPayable" runat="server" Text='<%# Util.GetString(Eval("isPayable"))=="1"?"Yes":"No" %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="75px" />
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Panel Co-Payment" HeaderStyle-Width="75px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <asp:Label runat="server" ID="lblCoPayment" Text='<%# Eval("CoPayment") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>





                        <asp:TemplateField>
                            <ItemTemplate>
                                <asp:Label ID="lblItemID" runat="server" Text='<%#Eval("ItemID") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblType_ID" runat="server" Text='<%#Eval("Type_ID") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblSubCategoryID" runat="server" Text='<%#Eval("SubCategoryID") %>'
                                    Visible="false"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                    </Columns>
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                </asp:GridView>

            </div>
            <div class="POuter_Box_Inventory">

                <table style="width: 100%; border-collapse: collapse">
                    <tr>
                        <td style="width: 6%">
                            <asp:Button ID="btnCalculator" runat="server" Text="Calculator" CssClass="ItDoseButton"
                                OnClick="btnCalculator_Click" OnClientClick="return calculateSurgery();" />
                        </td>
                        <td style="width: 10%; text-align: left;">Total&nbsp;Amt.&nbsp;:&nbsp;
                        </td>
                        <td style="width: 10%; text-align: left;">
                            <asp:Label ID="lblTotalAmt" runat="server" Style="text-align: left;" Width="100px"
                                CssClass="ItDoseLabelSp" />
                        </td>
                        <td style="width: 10%; text-align: right;">Approval :&nbsp;
                        </td>
                        <td style="width: 20%; text-align: left;">
                            <asp:DropDownList ID="ddlApproveBy" runat="server" Width="175px" />
                        </td>
                        <td style="width: 10%; text-align: right">Remarks :&nbsp;
                        </td>
                        <td style="width: 20%; text-align: left;">
                            <asp:TextBox ID="txtNarration" runat="server" Width="271px" CssClass="ItDoseTextinputText"
                                MaxLength="50" ToolTip="Enter Remarks" />
                        </td>
                    </tr>
                </table>

            </div>
            <div class="POuter_Box_Inventory" style="text-align: center;">

                <asp:Button ID="btnSave" runat="server" Text="Save" OnClick="btnSave_Click" CssClass="ItDoseButton"
                    ValidationGroup="save" OnClientClick="return validateSurgery();" />&nbsp;
               
            </div>
        </div>
        <asp:Panel ID="pnlAddItem" runat="server" CssClass="pnlOrderItemsFilter" Style="display: none;">
            <div class="Purchaseheader" id="dragHandle" runat="server">
                Add Item
            </div>
            <div class="content">
                <Ajax:UpdatePanel ID="updatePanel3" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                        <label class="labelForTag">
                            Type
                        </label>
                        <asp:DropDownList ID="ddlDocType" runat="server" Font-Bold="true" CssClass="ItDoseDropdownbox"
                            AutoPostBack="True" OnSelectedIndexChanged="ddlDocType_SelectedIndexChanged" />
                        <br />
                        <label class="labelForTag">
                            Doctor
                        </label>
                        <asp:ListBox Height="150px" Width="350px" ID="chkDoctor" runat="server" Font-Size="8pt"
                            CssClass="ItDoseDropdownbox" SelectionMode="Multiple"></asp:ListBox>
                        <br />
                        <div>
                            <div style="float: left; clear: both;">
                                <label class="labelForTag">
                                    Charges %</label>
                                <asp:TextBox ID="txtChargesPer" runat="server" Width="75px" Text="100" CssClass="ItDoseTextinputNum" />
                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" TargetControlID="txtChargesPer"
                                    FilterType="Numbers,Custom" ValidChars="." />
                            </div>
                            <div style="float: left; padding-left: 5px;">
                                <label class="labelForTag">
                                    Charges Amt</label>
                                <asp:TextBox ID="txtChargeAmt" runat="server" Width="75px" CssClass="ItDoseTextinputNum" />
                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender2" runat="server" TargetControlID="txtChargeAmt"
                                    FilterType="Numbers,Custom" ValidChars="." />
                            </div>
                        </div>
                    </ContentTemplate>
                </Ajax:UpdatePanel>
                <br />
                <div>
                    <div style="float: left; clear: both;">
                        <label class="labelForTag">
                            Disc%:</label>
                        <asp:TextBox ID="txtDiscPer" runat="server" Width="75px" CssClass="ItDoseTextinputNum" />
                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender3" runat="server" TargetControlID="txtDiscPer"
                            FilterType="Numbers,Custom" ValidChars="." />
                    </div>
                    <div style="float: left; padding-left: 5px;">
                        <label class="labelForTag">
                            DiscAmt. :</label>
                        <asp:TextBox ID="txtDiscAmt" runat="server" Width="75px" CssClass="ItDoseTextinputNum" />
                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender4" runat="server" TargetControlID="txtDiscAmt"
                            FilterType="Numbers,Custom" ValidChars="." />
                    </div>
                </div>
            </div>
            <div class="filterOpDiv">
                <asp:Button ID="btnAdd" runat="server" Text="Add" OnClientClick="return CheckDocCharge();"
                    CssClass="ItDoseButton" Width="60px" OnClick="btnAdd_Click" />
                &nbsp;&nbsp;&nbsp;&nbsp;
            <asp:Button ID="btnCancel" runat="server" Text="Cancel" CausesValidation="false"
                CssClass="ItDoseButton" Width="60px" />
            </div>
        </asp:Panel>
        <cc1:ModalPopupExtender ID="mpeItem" runat="server" CancelControlID="btnCancel" DropShadow="true"
            TargetControlID="btnAddItem" BackgroundCssClass="filterPupupBackground" PopupControlID="pnlAddItem"
            PopupDragHandleControlID="dragHandle" />
        <asp:Button ID="Button2" runat="server" Text="Button" Style="display: none;" CssClass="ItDoseButton" />
        <asp:Button ID="btnAddDirect" runat="server" Text="Button" OnClick="btnAddDirect_Click"
            Style="display: none;" CssClass="ItDoseButton" />
    </form>
</body>
</html>
