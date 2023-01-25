<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="CanteenIssue.aspx.cs" Inherits="Design_Kitchen_CanteenIssue" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%--<%@ Register Src="~/Design/Controls/wuc_PaymentDetailsJSON.ascx" TagName="wuc_PaymentControl" TagPrefix="uc2" %>--%>
<%@ Register Src="~/Design/Controls/UCPayment.ascx" TagName="PaymentControl" TagPrefix="UC2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <style type="text/css">
        .hover {
            background-color: LimeGreen;
            color: white;
            cursor: default;
        }

        .Counthover {
            background-color: LimeGreen;
            color: white;
            cursor: pointer;
            font-size: 14px;
        }
        .auto-style1 {
            width: 16%;
            height: 21px;
        }
        .auto-style2 {
            width: 44%;
            height: 21px;
        }
        .auto-style3 {
            width: 40%;
            height: 21px;
        }
    </style>
    <script type="text/javascript" src="../../Scripts/jquery.extensions.js"></script>
    <script type="text/javascript" src="../../Scripts/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="../../Scripts/json2.js"></script>
    <link rel="stylesheet" type="text/css" href="../../Styles/easyui.css">

    <script type="text/javascript">

        $(document).ready(function () {
            $paymentControlInit(function () {
            });
        });


        $(function () {
            $('#txtDiscItem').bind("keyup", function () {
                if ($(this).val().charAt(0) == ".") {
                    $(this).val('0.');
                    return;
                }
                var itemDisPer = Number($('#txtDiscItem').val());
                if (itemDisPer > 100) {
                    $("#spnMsg").text('Please Enter Valid Percentage');
                    $('#txtDiscItem').val('');
                    $('#txtDiscItem').focus();
                    return;
                }
            });
            $('#txtGenContact').bind("keyup", function (e) {
                $('#canteenItem').next().find('input').prop('tabIndex', 5);
                $('#txtTransferQty').removeAttr('tabIndex').attr('tabIndex', 6);
                $('#txtDiscItem').removeAttr('tabIndex').attr('tabIndex', '7');
                $('#btnSave').removeAttr('tabIndex').attr('tabIndex', 8);
            });
            $('#txtIPDNo').bind("keyup", function (e) {
                $("#txtBarcode").val('');
                var code = (e.keyCode ? e.keyCode : e.which);
                if (code == 13) {
                    e.preventDefault();
                    bindCanteenDetail();
                    $('#canteenItem').next().find('input').focus();
                    $('#canteenItem').next().find('input').attr('tabIndex', '3');
                    $('#txtTransferQty').removeAttr('tabIndex').attr('tabIndex', '4');
                    $('#txtDiscItem').removeAttr('tabIndex').attr('tabIndex', '5');
                    $('#btnSave').removeAttr('tabIndex').attr('tabIndex', '6');
                }
                if (code == 9) {
                    $('#canteenItem').next().find('input').focus();
                }
            });
            $('#txtMRNo').bind("keydown keyup", function (e) {
                $("#txtBarcode").val('');
                var code = (e.keyCode ? e.keyCode : e.which);
                if (code == 13) {
                    e.preventDefault();
                    bindCanteenDetail();
                    $('#canteenItem').next().find('input').attr('tabIndex', '3');
                    $('#txtTransferQty').removeAttr('tabIndex').attr('tabIndex', '4');
                    $('#txtDiscItem').removeAttr('tabIndex').attr('tabIndex', '5');
                    $('#btnSave').removeAttr('tabIndex').attr('tabIndex', '6');
                    $('#canteenItem').next().find('input').focus();
                }
                if (code == 9) {
                    $('#canteenItem').next().find('input').focus();
                }
            });
            $('#txtTransferQty,#txtDiscItem').bind("keyup", function (e) {
                var code = (e.keyCode ? e.keyCode : e.which);
                if (code == 13) {
                    var g = $('#canteenItem').combogrid('grid');
                    var r = g.datagrid('getSelected');
                    var con = 0;
                    if (r != null) {
                        //if (parseFloat( $('#txtTransferQty').val()) > parseFloat(r.AvlQty)) {
                        //    var Ok = confirm('Only ' + r.AvlQty + ' Quantity Available');
                        //    if (Ok)
                        //        con = 0;
                        //    else
                        //        con = 1;
                        //}
                        if (con == "0")
                            addCanteenItem($("#canteenItem").combogrid('getValue'));
                        $('#canteenItem').combogrid('reset');
                        $("#canteenItem").combogrid('clear');
                        $('#canteenItem').next().find('input').focus();
                    }
                }
                if (code == 9) {
                    $(this).next(':input').focus();
                }
            });
            setTab();
        });

        function setTab() {
            $('#canteenItem').next().find('input').prop('tabIndex', 2);
            $('#txtTransferQty').removeAttr('tabIndex').attr('tabIndex', 3);
            $('#txtDiscItem').removeAttr('tabIndex').attr('tabIndex', 4);
            $('#btnAddMed').removeAttr('tabIndex').attr('tabIndex', 5);
        }
    </script>
    <script type="text/javascript">
        jQuery(function () {
            jQuery("#txtGenName").focus();
            jQuery("#<%=lstItems.ClientID %> option").each(function () {
                if (jQuery(this).val().split('#')[1] == "1") {
                    jQuery(this).css('color', 'red');
                }
            });
            $("#txtBarcode").keypress(function (e) {
                jQuery("#txtMRNo,#txtIPDNo").val('');
                var key = (e.keyCode ? e.keyCode : e.charCode);
                if (key == 13) {
                    e.preventDefault();
                    if ($.trim($("#txtBarcode").val()) != "")
                        bindCanteenDetail();
                }
            });
        });
    </script>

    <cc1:ToolkitScriptManager ID="ScriptManager1" EnablePageMethods="true" runat="server" EnableScriptGlobalization="true" EnableScriptLocalization="true"></cc1:ToolkitScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Canteen Issue</b><br />
            <span id="spnMsg" class="ItDoseLblError"></span>
            <br />
            <span id="spnCanteenIssue"></span>
            <asp:TextBox ID="lblDeptLedgerNo" runat="server" Style="display: none" ClientIDMode="Static"></asp:TextBox>
            <input type="text" id="txtHash" style="display: none" />
            <input type="radio" id="rdoHospitalPatient" value="1" name="group1" onclick="chkPatientType()" style="display:none;" />
            <span style="display: none;">Hospital Patient</span>
            <input type="radio" id="rdoGeneral" value="2" name="group1" onclick="chkPatientType()" checked="checked" style="display:none;" />
            <span style="display: none;">General</span>
            <input type="radio" id="rdoIPD" value="3" name="group1" onclick="chkPatientType()" style="display:none;" />
            <span style="display: none;">IPD</span>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <asp:Panel ID="pnlOPD" runat="server" ClientIDMode="Static" Style="display: none;">
                <table border="0" style="width: 100%; border-collapse: collapse">
                    <tr>
                        <td style="width: 20%; text-align: right">
                            <strong>Barcode Search :</strong>&nbsp;
                        </td>
                        <td style="width: 20%; text-align: left">
                            <input type="text" id="txtBarcode" maxlength="20" />
                        </td>
                        <td style="width: 20%; text-align: right">
                            <span id="spnType">MR No. :&nbsp;</span>
                        </td>
                        <td style="width: 20%; text-align: left">
                            <input type="text" id="txtMRNo" style="width: 120px" maxlength="20" />
                            <asp:TextBox ID="txtIPDNo" Style="display: none" ClientIDMode="Static" runat="server" Width="120px" TabIndex="1"></asp:TextBox>
                            <span style="color: red; font-size: 10px;" class="shat">*</span>
                            <cc1:FilteredTextBoxExtender ID="ftbIPDNo" runat="server" FilterType="Numbers" TargetControlID="txtIPDNo"></cc1:FilteredTextBoxExtender>
                        </td>
                        <td style="text-align: left; width: 10%;">
                            <input type="button" id="btnCanteenSearch" class="ItDoseButton" onclick="bindCanteenDetail()" value="Search" />
                        </td>
                        <td style="width: 10%; text-align: left">
                            <input type="button" id="btnOldPatient" class="ItDoseButton" value="Old Patient" />
                        </td>
                    </tr>
                </table>
            </asp:Panel>
            <asp:Panel ID="pnlGeneral" runat="server" ClientIDMode="Static">
                <table border="0" style="width: 100%; border-collapse: collapse">
                    <tr>
                        <td style="width: 15%; text-align: right">Name :&nbsp;</td>
                        <td style="width: 30%; text-align: left">
                            <asp:DropDownList ID="ddlTitle" runat="server" ToolTip="Select Title" Width="55px" TabIndex="1" onchange="AutoGender();" ClientIDMode="Static"></asp:DropDownList>
                            <asp:TextBox ID="txtGenName" runat="server" ClientIDMode="Static" Width="160px" TabIndex="1" onkeypress="return check(this,event)" AutoCompleteType="Disabled" onkeyup="validatespace();" MaxLength="100"></asp:TextBox>
                            <span style="color: red; font-size: 10px; display: none;" class="shat">*</span>
                        </td>
                        <td style="text-align: right; width: 11%;"><span style="display:none;">Age : &nbsp;</span></td>
                        <td style="width: 35%; text-align: left">
                            <asp:TextBox ID="txtGenAge" runat="server" Width="65px" ClientIDMode="Static" AutoCompleteType="Disabled" MaxLength="4" TabIndex="2" onkeyup="ValidateAge()" onkeypress="return checkForSecondDecimal(this);" style="display:none;"></asp:TextBox>
                            <span style="color: red; font-size: 10px; display: none;" class="shat">*</span>
                            <asp:DropDownList ID="ddlAge" runat="server" Width="85px" ClientIDMode="Static" style="display:none;">
                                <asp:ListItem Value="YRS">YRS</asp:ListItem>
                                <asp:ListItem Value="MONTH(S)">MONTH(S)</asp:ListItem>
                                <asp:ListItem Value="DAYS(S)">DAYS(S)</asp:ListItem>
                            </asp:DropDownList>
                            <cc1:FilteredTextBoxExtender ID="Fage" runat="Server" FilterType="Numbers,Custom" TargetControlID="txtGenAge" ValidChars="."></cc1:FilteredTextBoxExtender>
                        </td>
                    </tr>
                    <tr style="display:none;">
                        <td style="width: 15%; text-align: right">Address :&nbsp;
                        </td>
                        <td style="width: 30%; text-align: left">
                            <asp:TextBox ID="txtGenAddress" AutoCompleteType="Disabled" runat="server" Width="220px" ClientIDMode="Static" TabIndex="3" MaxLength="200"></asp:TextBox>
                            <span style="color: red; font-size: 10px; display: none;" class="shat">*</span>
                        </td>
                        <td style="text-align: right; width: 11%;">Sex : &nbsp;</td>
                        <td style="text-align: left">
                            <asp:RadioButtonList ID="rdoGenGender" runat="server" RepeatDirection="Horizontal" class="rad" Width="150px" ToolTip="Select Gender" TabIndex="4" ClientIDMode="Static">
                                <asp:ListItem Value="Male" Text="Male" Selected="True"></asp:ListItem>
                                <asp:ListItem Value="Female" Text="Female"></asp:ListItem>
                            </asp:RadioButtonList>
                        </td>
                    </tr>
                    <tr style="display:none;">
                        <td style="width: 15%; text-align: right">Contact No. :&nbsp;</td>
                        <td style="width: 30%; text-align: left">
                            <asp:TextBox ID="txtGenContact" AutoCompleteType="Disabled" runat="server" Width="150px" TabIndex="5" MaxLength="15" ToolTip="Enter Contact No." ClientIDMode="Static"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="ftbGenContact" runat="server" FilterType="Numbers" TargetControlID="txtGenContact"></cc1:FilteredTextBoxExtender>
                        </td>
                        <td style="text-align: right; width: 11%;">&nbsp;</td>
                        <td style="width: 35%; text-align: left"></td>
                    </tr>
                </table>
            </asp:Panel>
        </div>
        <asp:Panel ID="pnlInfo" runat="server" Style="display: none" ClientIDMode="Static">
            <div class="POuter_Box_Inventory" style="text-align: center">
                <div>
                    <table border="0" style="width: 100%; border-collapse: collapse">
                        <tr>
                            <td style="width: 15%; text-align: right">Patient Name :&nbsp;</td>
                            <td style="width: 30%; text-align: left">
                                <span id="spnPName" class="ItDoseLabelSp"></span>
                            </td>
                            <td style="width: 11%; text-align: right">MR No. :&nbsp;</td>
                            <td style="width: 35%; text-align: left">
                                <span id="spnPatientID" class="ItDoseLabelSp"></span>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 15%; text-align: right">Age / Sex  :&nbsp;</td>
                            <td style="width: 30%; text-align: left">
                                <span id="spnAge" class="ItDoseLabelSp"></span>
                            </td>
                            <td style="width: 11%; text-align: right">Contact No. :&nbsp;</td>
                            <td style="width: 35%; text-align: left">
                                <span id="spnContactNo" class="ItDoseLabelSp"></span>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 15%; text-align: right">Address :&nbsp;</td>
                            <td style="width: 30%; text-align: left">
                                <span id="spnAddress" class="ItDoseLabelSp"></span>
                                <span id="spnIPDNo" class="ItDoseLabelSp" style="display: none"></span>
                                <span id="spnHospPatientType" class="ItDoseLabelSp" style="display: none"></span>
                            </td>
                            <td style="width: 35%; text-align: left" colspan="2"></td>
                        </tr>
                        <tr>
                            <td style="width: 15%; text-align: right">Doctor :&nbsp;</td>
                            <td style="width: 30%; text-align: left">
                                <asp:DropDownList ID="ddlDoctor" ClientIDMode="Static" runat="server" Width="238px" TabIndex="1" />
                                <span style="color: red; font-size: 10px;" class="shat">*</span>
                            </td>
                            <td style="width: 11%; text-align: right">Panel :&nbsp;</td>
                            <td style="width: 35%; text-align: left">
                                <asp:DropDownList ID="ddlPanelCompany" runat="server" ClientIDMode="Static" Width="258px" TabIndex="1" onchange="bindPaymentMode();" />
                                <span style="color: red; font-size: 10px;" class="shat">*</span>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </asp:Panel>
        <asp:Panel ID="pnlAllInfo" runat="server" ClientIDMode="Static">
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Items
                </div>
                <table style="width: 100%; border-collapse: collapse">
                    <tr>
                        <td class="auto-style1"></td>
                        <td class="auto-style2"></td>
                        <td class="auto-style3"></td>
                    </tr>
                    <tr style="display: none">
                        <td style="width: 16%; text-align: right;">By&nbsp;First&nbsp;Name&nbsp;:&nbsp;</td>
                        <td style="width: 40%; text-align: left;">
                            <asp:TextBox ID="txtSearch" Style="display: none" runat="server" AutoCompleteType="Disabled" class="cls" MaxLength="50"
                                onKeyDown="MoveUpAndDownText(ctl00$ContentPlaceHolder1$txtSearch,ctl00$ContentPlaceHolder1$lstItems);" onkeyup="suggestName(ctl00$ContentPlaceHolder1$txtSearch,ctl00$ContentPlaceHolder1$lstItems);" ToolTip="Enter First Name To Search Items" Width="232px" />
                            <asp:TextBox ID="txtItemCode" runat="server" AutoCompleteType="Disabled" CssClass="ItDoseTextinputText" Style="display: none" ToolTip="Enter Item Code"> </asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="validaterelationno" runat="server" FilterType="Numbers" TargetControlID="txtItemCode"></cc1:FilteredTextBoxExtender>
                        </td>
                        <td style="width: 40%"></td>
                    </tr>
                    <tr>
                        <td style="width: 16%; text-align: right;">Meal:&nbsp;</td>
                        <td style="width: 360px; height: 24px; text-align: left; font: bold">
                            <input id="canteenItem" class="easyui-combogrid" style="width: 250px; height: 60px" data-options="
			                panelWidth: 700,
			                idField: 'ItemID',
			                textField: 'ItemName',
                            mode:'remote',                                       
			                url: 'CanteenIssue.aspx?cmd=item',
                            loadMsg: 'Serching... ',
			                method: 'get',
                            pagination:true,
                            rownumbers:true,
                            fit:true,
                            border:false,   
                            cache:false,  
                            nowrap:true,                                                   
                            emptyrecords: 'No records to display.',                            
                            onHidePanel: function(){ },           
			                columns: [[
				                {field:'ItemName',title:'ItemName',width:260,align:'left'},
                                {field:'HSNCode',title:'HSN Code',width:100,align:'center'},   
				                {field:'BatchNumber',title:'Batch No.',width:120,align:'center'},
        		                {field:'AvlQty',title:'Avl. Qty.',width:70,align:'right'},
		                        {field:'Expiry',title:'Expiry',width:100,align:'center'},
                                {field:'MRP',title:'MRP',width:80,align:'right'},
                                {field:'Rack',title:'Rack',width:80,align:'center'},
                                {field:'Shelf',title:'Shelf',width:80,align:'center'}			      				
			                ]],
			                fitColumns: true
		                ">
                        </td>
                        <td style="width: 40%"></td>
                    </tr>
                    <tr>
                        <td style="width: 16%; text-align: right;">&nbsp;</td>
                        <td style="width: 40%; text-align: left;">
                            <asp:ListBox ID="lstItems" Style="display: none" runat="server" Height="104px" ClientIDMode="Static" Width="460px" onchange="LoadDetail();"></asp:ListBox>
                        </td>
                        <td style="width: 40%">
                            <table style="width: 100%">
                                <tr>
                                    <td>
                                        <div id="div_Items" style="width: 100%"></div>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 16%; text-align: right;">Qty. :&nbsp;</td>
                        <td style="width: 40%; text-align: left;">
                            <table style="width: 100%; border-collapse: collapse">
                                <tr>
                                    <td style="text-align: left; width: 16%">
                                        <asp:TextBox ID="txtTransferQty" ClientIDMode="Static" runat="server" AutoCompleteType="Disabled" CssClass="ItDoseTextinputNum" MaxLength="4" onkeypress="return checkForSecondDecimal(this,event)" Width="50px"> </asp:TextBox>
                                        <cc1:FilteredTextBoxExtender ID="txtTransferQty_FilteredTextBoxExtender" runat="server" TargetControlID="txtTransferQty" ValidChars="0123456789"></cc1:FilteredTextBoxExtender>
                                    </td>
                                    <td style="text-align: right; width: 22%">
                                        <%--Disc.(%)&nbsp;:&nbsp;--%>
                                    </td>
                                    <td style="text-align: left; width: 16%">
                                        <asp:TextBox ID="txtDiscItem" ClientIDMode="Static" runat="server" Style="display: none" CssClass="ItDoseTextinputNum" AutoCompleteType="Disabled" MaxLength="8" onkeypress="return checkForSecondDecimal(this,event)" ReadOnly="false" Width="50px" Text="0"> </asp:TextBox>
                                        <cc1:FilteredTextBoxExtender ID="ftbDisc" runat="server" FilterMode="validChars" FilterType="Custom, Numbers" TargetControlID="txtDiscItem" ValidChars="."></cc1:FilteredTextBoxExtender>
                                    </td>
                                    <td style="text-align: left">
                                        <input type="button" value="Add" onclick="addCanteenItem($('#canteenItem').combogrid('getValue'))" class="ItDoseButton" tabindex="8" id="btnAddMed" />
                                    </td>
                                    <td style="text-align: left">
                                        <table style="width: 100%; border-collapse: collapse; display: none" class="itemWiseDisc">
                                            <tr>
                                                <td style="text-align: right">&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                                <td style="text-align: left">
                                                    <input type="button" onclick="removeItemWiseDisc()" class="ItDoseButton" value="Remove ItemWise Disc." />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 16%; text-align: right;"></td>
                        <td style="width: 40%; text-align: left;"></td>
                        <td style="width: 40%; text-align: left"></td>
                    </tr>
                </table>
            </div>
            <div class="POuter_Box_Inventory" id="div_Item" style="display: none">
                <div class="Purchaseheader">
                    Batch Type Item Selection
                </div>
                <div id="ItemOutput" style="max-height: 600px; overflow-x: auto;"></div>
                <div style="width: 100%; text-align: center;">
                    <input type="button" style="display: none" value="Add Item" class="ItDoseButton" id="btnAddItem" onclick="addItem()" />
                    <input type="button" style="display: none" value="Cancel" class="ItDoseButton" id="btnRCancel" />
                </div>
            </div>
            <div class="POuter_Box_Inventory" id="div_Issue" style="display: none">
                <div class="Purchaseheader">
                    Prescribed Medicines <span id="spnTotalMedicine"></span>
                </div>
                <div style="text-align: center;">
                    <table style="width: 100%; border-collapse: collapse">
                        <tr style="text-align: center">
                            <td colspan="4">
                                <table class="GridViewStyle" border="1" id="tb_grdIssueItem" style="width: 99.99%; border-collapse: collapse; display: none;">
                                    <tr id="IssueItemHeader">
                                        <th class="GridViewHeaderStyle" scope="col" style="width: 390px;">Item Name</th>
                                        <th class="GridViewHeaderStyle" scope="col" style="width: 140px;">Batch No.</th>
                                        <th class="GridViewHeaderStyle" scope="col" style="width: 60px;display:none;">IsExpirable</th>
                                        <th class="GridViewHeaderStyle" scope="col" style="width: 80px;">HSNCode</th>
                                        <th class="GridViewHeaderStyle" scope="col" style="width: 110px;">Expiry</th>
                                        <th class="GridViewHeaderStyle" scope="col" style="width: 60px;">Unit</th>
                                        <th class="GridViewHeaderStyle" scope="col" style="width: 90px;">Stock Qty.</th>
                                        <th class="GridViewHeaderStyle" scope="col" style="width: 50px;">Qty.</th>
                                        <th class="GridViewHeaderStyle" scope="col" style="width: 80px;">Unit&nbsp;Cost</th>
                                        <th class="GridViewHeaderStyle" scope="col" style="width: 80px;">Discount</th>
                                        <th class="GridViewHeaderStyle" scope="col" style="width: 50px;display:none;">IGST%</th>
                                        <th class="GridViewHeaderStyle" scope="col" style="width: 50px;">CGST%</th>                                        
                                        <th class="GridViewHeaderStyle" scope="col" style="width: 50px;">SGST%</th>                                        
                                        <th class="GridViewHeaderStyle" scope="col" style="width: 80px;">Total&nbsp;Cost</th>
                                        <th class="GridViewHeaderStyle" scope="col" style="width: 60px; display:  none">GrossAmt</th>
                                        <th class="GridViewHeaderStyle" scope="col" style="width: 60px; display:  none">isItemWiseDisc</th>
                                        <th class="GridViewHeaderStyle" scope="col" style="width: 160px; display: none">DisPer</th>
                                        <th class="GridViewHeaderStyle" scope="col" style="width: 160px; display: none">StockID</th>
                                        <th class="GridViewHeaderStyle" scope="col" style="width: 160px; display: none">ItemID</th>
                                        <th class="GridViewHeaderStyle" scope="col" style="width: 160px; display: none">SubCategoryID</th>
                                        <th class="GridViewHeaderStyle" scope="col" style="width: 160px; display: none">ToBeBilled</th>
                                        <th class="GridViewHeaderStyle" scope="col" style="width: 160px; display: none">Type_ID</th>
                                        <th class="GridViewHeaderStyle" scope="col" style="width: 160px; display: none">IsUsable</th>
                                        <th class="GridViewHeaderStyle" scope="col" style="width: 160px; display: none">ServiceItemID</th>
                                        <th class="GridViewHeaderStyle" scope="col" style="width: 160px; display: none">PatientMedicine_ID</th>
                                        <th class="GridViewHeaderStyle" scope="col" style="width: 160px; display: none">GSTType</th>                                        
                                        <th class="GridViewHeaderStyle" scope="col" style="width: 60px;">Remove</th>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            <div class="POuter_Box_Inventory" id="divSave" style="display: none">
                <table style="width: 100%">
                    <tr>
                        <td style="width: 25%">&nbsp;</td>
                        <td style="text-align: right; width: 25%; font: bold">
                            <asp:Label ID="lblBill" Text="Total Bill Amount :" ClientIDMode="Static" runat="server" Style="display: none" Font-Bold="true"></asp:Label>
                        </td>
                        <td style="text-align: left; width: 25%">
                            <asp:Label ID="lblBillAmount" runat="server" Font-Bold="true" ClientIDMode="Static" Style="display: none"></asp:Label>
                            <asp:Label ID="lblDiscAmount" runat="server" Font-Bold="true" ClientIDMode="Static" Style="display: none"></asp:Label>
                            <asp:Label ID="lblGrossAmt" runat="server" Font-Bold="true" ClientIDMode="Static" Style="display: none"></asp:Label>
                            <asp:Label ID="lblItemWiseDisc" runat="server" Font-Bold="true" ClientIDMode="Static" Style="display: none"></asp:Label>
                        </td>
                        <td style="width: 25%">&nbsp;</td>
                    </tr>
                </table>
            </div>
             <div style="width: 100%; display: none" id="paymentControlDiv">
            <UC2:PaymentControl ID="paymentControl" runat="server" />
        </div>
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <input type="button" value="Save" class="ItDoseButton" id="btnSave" tabindex="9" style="display: none" />
            </div>
        </asp:Panel>
    </div>
    <script id="tb_Item" type="text/html">
        <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_grdItem" style="width:950px;border-collapse:collapse;">
            <tr id="Header">
			    <th class="GridViewHeaderStyle" scope="col" style="width:10px;"></th>
			    <th class="GridViewHeaderStyle" scope="col" style="width:340px;">Item Name</th>
			    <th class="GridViewHeaderStyle" scope="col" style="width:240px;">Batch No.</th>
			    <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Expirable</th>	
			    <th class="GridViewHeaderStyle" scope="col" style="width:160px;">Expiry</th>		          
			    <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Buy&nbsp;Price</th>	
			    <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Selling&nbsp;Price</th>	
			    <th class="GridViewHeaderStyle" scope="col" style="width:160px;">Available&nbsp;Qty.</th>	
			    <th class="GridViewHeaderStyle" scope="col" style="width:180px;">Unit</th>	               
			    <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Issue&nbsp;Qty.</th>	
			    <th class="GridViewHeaderStyle" scope="col" style="width:80px;display:none; ">ItemID</th>	
			    <th class="GridViewHeaderStyle" scope="col" style="width:80px;display:none; ">stockID</th>	
			    <th class="GridViewHeaderStyle" scope="col" style="width:80px;display:none; ">SubCategoryID</th>	
			    <th class="GridViewHeaderStyle" scope="col" style="width:80px;display:none; ">ToBeBilled</th>	
			    <th class="GridViewHeaderStyle" scope="col" style="width:80px;display:none; ">Type_ID</th>	
			    <th class="GridViewHeaderStyle" scope="col" style="width:80px;display:none; ">IsUsable</th>	
			    <th class="GridViewHeaderStyle" scope="col" style="width:80px;display:none; ">ServiceItemID</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:40px;display:none; ">IsTaxApplicable</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:40px;display:none; ">HSNCode</th>	           	           
                <th class="GridViewHeaderStyle" scope="col" style="width:40px;display:none; ">IGSTTaxPercent</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:40px;display:none; ">CGSTTaxPercent</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:40px;display:none; ">SGSTTaxPercent</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:40px;display:none; ">GSTType</th>
		    </tr>
            <#       
                var dataLength=Newitem.length;
                var objRow;   
                for(var j=0;j<dataLength;j++)
                {       
                    objRow = Newitem[j];
            #>
					<tr id="<#=j+1#>"> 
                      <#  if(objRow.MRP =='0')
                        {#>
                        <td class="GridViewLabItemStyle" id="tdItemChk" style="width:10px;"><input type="checkbox" id="chkItem"  disabled="true"  <#=j+1#></td>
                     <#}
                        else
                        {#>
					<td class="GridViewLabItemStyle" id="tdItemChk" style="width:10px;"><input type="checkbox" id="chkItem"<#=j+1#></td>
                       <#}#>
					<td class="GridViewLabItemStyle" id="tdItemName"  style="width:340px;text-align:left" ><#=objRow.ItemName#></td>
					<td class="GridViewLabItemStyle" id="tdBatchNumber"  style="width:240px;text-align:center" ><#=objRow.BatchNumber#></td>
					<td class="GridViewLabItemStyle" id="tdisExpirable"  style="width:100px;text-align:center" ><#=objRow.isexpirable#></td>
					<td class="GridViewLabItemStyle" id="tdMedExpiryDate" style="width:160px;text-align:center; "><#=objRow.MedExpiryDate#></td>
					<td class="GridViewLabItemStyle" id="tdUnitPrice" style="width:120px;text-align:right;"><#=objRow.UnitPrice#></td>
					<td class="GridViewLabItemStyle" id="tdMRP" style="width:120px;text-align:right;"><#=objRow.MRP#></td>
					<td class="GridViewLabItemStyle" id="tdAvlQty" style="width:160px;text-align:right"><#=objRow.AvlQty#></td>
					<td class="GridViewLabItemStyle" id="tdUnitType" style="width:180px;text-align:center"><#=objRow.UnitType#></td>
                    <# if(objRow.MRP =='0')
                        {#>
					<td class="GridViewLabItemStyle" id="tdIssueQty" style="width:80px;text-align:center;"><input type="text" style="width:60px" id="txtIssueQty" maxlength="4" disabled="true" onkeypress="return checkForSecondDecimal(this,event)" class="ItDoseTextinputNum"  onkeyup="CheckQty(this);"></td>
					 <#}
                    else
                        {#>
                        <td class="GridViewLabItemStyle" id="tdIssueQty" style="width:80px;text-align:center"><input type="text" style="width:60px" id="txtIssueQty" maxlength="4" onkeypress="return checkForSecondDecimal(this,event)" class="ItDoseTextinputNum"  onkeyup="CheckQty(this);"></td>
                         <#}#>
                        <td class="GridViewLabItemStyle" id="tdItemID" style="width:180px;text-align:center;display:none"><#=objRow.ItemID#></td>
					<td class="GridViewLabItemStyle" id="tdstockID" style="width:180px;text-align:center;display:none"><#=objRow.stockid#></td>
					<td class="GridViewLabItemStyle" id="tdSubCategoryID" style="width:180px;text-align:center;display:none"><#=objRow.SubCategoryID#></td>
					<td class="GridViewLabItemStyle" id="tdToBeBilled" style="width:180px;text-align:center;display:none"><#=objRow.ToBeBilled#></td>
					<td class="GridViewLabItemStyle" id="tdType_ID" style="width:180px;text-align:center;display:none"><#=objRow.Type_ID#></td>
					<td class="GridViewLabItemStyle" id="tdIsUsable" style="width:180px;text-align:center;display:none"><#=objRow.IsUsable#></td>
					<td class="GridViewLabItemStyle" id="tdServiceItemID" style="width:80px;text-align:center;display:none"><#=objRow.ServiceItemID#></td>
					<td class="GridViewLabItemStyle" id="tdIsTaxApplicable" style="width:40px;text-align:center;display:none"><#=objRow.IsTaxApplicable#></td>
                    <td class="GridViewLabItemStyle" id="tdMedID" style="width:40px;text-align:center;display:none"><#=objRow.MedID#></td>
                    <td class="GridViewLabItemStyle" id="tdHSNCode" style="width:40px;text-align:center;display:none"><#=objRow.HSNCode#></td>
                    <td class="GridViewLabItemStyle" id="tdIGSTTaxPercent" style="width:40px;text-align:center;display:none"><#=objRow.IGSTPercent#></td>
                    <td class="GridViewLabItemStyle" id="tdCGSTTaxPercent" style="width:40px;text-align:center;display:none"><#=objRow.CGSTPercent#></td>
                    <td class="GridViewLabItemStyle" id="tdSGSTTaxPercent" style="width:40px;text-align:center;display:none"><#=objRow.SGSTPercent#></td>
                    <td class="GridViewLabItemStyle" id="tdGSTType" style="width:40px;text-align:center;display:none"><#=objRow.GSTType#></td>
                 </tr>            
		    <#}#>      
        </table>    
    </script>
    <script type="text/javascript">
        function bindCanteenDetail() {
            jQuery("#spnMsg").text('');
            var patientID = "";
            if ($.trim($("#txtMRNo").val()) != "")
                patientID = $.trim($("#txtMRNo").val());
            else
                patientID = $.trim($("#txtBarcode").val());
            if (($.trim(patientID) == "") && (jQuery("#rdoHospitalPatient").is(':checked'))) {
                jQuery("#spnMsg").text('Please Enter MR No.');
                jQuery("#txtMRNo").focus();
                return;
            }
            else if (($.trim($("#txtIPDNo").val()) == "") && (jQuery("#rdoIPD").is(':checked')) && (patientID == "")) {
                jQuery("#spnMsg").text('Please Enter IPD No.');
                jQuery("#txtIPDNo").focus();
                return;
            }
            else {
                $("#txtSearch").focus();
                jQuery.ajax({
                    url: "CanteenIssue.aspx/bindData",
                    data: '{PatientID:"' + patientID + '",type:"' + $('input[name=group1]:checked').val() + '",IPDNo:"' + $.trim($("#txtIPDNo").val()) + '"}',
                    type: "POST",
                    dataType: "json",
                    contentType: "application/json; charset=utf-8",
                    success: function (mydata) {
                        var OPDData = jQuery.parseJSON(mydata.d);
                        if ((OPDData != "") && (OPDData != null)) {
                            jQuery("#spnPName").text(OPDData[0]["PName"]);
                            jQuery("#spnPatientID").text(OPDData[0]["Patient_ID"]);
                            jQuery("#spnAge").text(OPDData[0]["Age"] + " / " + OPDData[0]["Gender"]);
                            jQuery("#spnContactNo").text(OPDData[0]["ContactNo"]);
                            jQuery("#spnAddress").text(OPDData[0]["Address"]);
                            jQuery("#spnIPDNo").text(OPDData[0]["Transaction_ID"]);
                            jQuery("#spnHospPatientType").text(OPDData[0]["HospPatientType"]);

                            jQuery("#pnlInfo,#pnlAllInfo").show();
                            // if (OPDData[0]["Panel_ID"] != "")
                            //      jQuery('#ddlPanelCompany').val(OPDData[0]["Panel_ID"]).removeAttr('disabled');
                            //   else
                            jQuery("#ddlPanelCompany").val('<%=Resources.Resource.DefaultPanelID %>');
                            // jQuery('#ddlPanelCompany').attr('disabled', 'disabled');
                            if (OPDData[0]["Doctor_ID"] != "")
                                jQuery('#ddlDoctor').val(OPDData[0]["Doctor_ID"]);
                            getCurrentDate();
                        }
                        else {
                            jQuery("#spnMsg").text('Record Not Found');
                            jQuery("#pnlInfo,#pnlAllInfo").hide();
                        }
                    },
                    error: function (xhr, status) {
                        jQuery("#spnMsg").text('Error occurred, Please contact administrator');
                    }
                });
            }
        jQuery("#<%=txtSearch.ClientID%>").focus();
        }
    </script>
    <script type="text/javascript">
        function precise_round(num, decimals) {
            return Math.round(num * Math.pow(10, decimals)) / Math.pow(10, decimals);
        }
        function addItem() {
            var con = 0; var chk = 1;
            jQuery("#tb_grdItem tr").each(function () {
                var id = jQuery(this).closest("tr").attr("id");
                var $rowid = jQuery(this).closest("tr");
                if (id != "Header") {
                    if (jQuery(this).find("#chkItem").is(":checked")) {
                        if (jQuery.trim(jQuery(this).find("#txtIssueQty").val()) < "0") {
                            jQuery("#spnMsg").text('Please Enter Issue Qty.');
                            jQuery(this).find("#txtIssueQty").focus();
                            con = 1;
                            return false;
                        }
                        chk += chk;
                        if (parseFloat(jQuery.trim(jQuery(this).find("#txtIssueQty").val())) > parseFloat((jQuery.trim($rowid.find("#tdAvlQty").html())))) {
                            jQuery("#spnMsg").text('Issue Qty. Can Not Greater Then Available Qty.');
                            con = 1;
                            return false;
                        }
                        var stockID = $rowid.find("#tdstockID").html();
                        jQuery("#tb_grdIssueItem tr").each(function () {
                            var IssueItemid = jQuery(this).closest("tr").attr("id");
                            var $IssueItemrowid = jQuery(this).closest("tr");
                            if (IssueItemid != "IssueItemHeader") {
                                var IssuestockID = $IssueItemrowid.find("#tdStockID").html();
                                if (stockID == IssuestockID) {
                                    jQuery("#spnMsg").text('Item Already Selected');
                                    jQuery("#<%=txtSearch.ClientID%>").focus();
                                    con = 1;
                                    return false;
                                }
                            }

                        });
                    }
                }
            });
            if (chk == "1") {
                jQuery("#spnMsg").text('Please Check Atleast One Item');
                return false;
            }
            var totalAmt = 0; var totalDisc = 0; var totalGrossAmt = 0; var isItemWiseDisc = 0;
            if ((con == "0") && (chk > 1)) {
                jQuery("#spnMsg").text('');
                jQuery("#tb_grdItem tr").each(function () {
                    var id = jQuery(this).attr("id");
                    var disc = 0; var amt = 0;
                    var $rowid = jQuery(this).closest("tr");
                    if ((id != "Header") && ($rowid.find("#chkItem").is(':checked'))) {
                        RowCount = jQuery("#tb_grdIssueItem tr").length;
                        RowCount = RowCount + 1;
                        var newRow = jQuery('<tr />').attr('id', 'tr_' + RowCount);
                        if (($.trim($("#txtDiscItem").val()) != "") && ($.trim($("#txtDiscItem").val()) > 0)) {
                            disc = precise_round(parseFloat((parseFloat(jQuery(this).find('#txtIssueQty').val()) * parseFloat(($rowid.find('#tdMRP').html())) * parseFloat($.trim($("#txtDiscItem").val()))) / 100), 2);
                            amt = precise_round(parseFloat((parseFloat(jQuery(this).find('#txtIssueQty').val()) * parseFloat(($rowid.find('#tdMRP').html()))) - disc), 2);
                            isItemWiseDisc = 1;
                        }
                        else {
                            amt = precise_round(parseFloat((parseFloat(jQuery(this).find('#txtIssueQty').val()) * parseFloat(($rowid.find('#tdMRP').html())))), 2);
                            disc = 0;
                            isItemWiseDisc = 0;
                        }
                        newRow.html(
                             '</td><td class="GridViewLabItemStyle" id="tdItemName">' + $rowid.find("#tdItemName").html() +
                             '</td><td class="GridViewLabItemStyle" id="tdBatchNumber">' + $rowid.find('#tdBatchNumber').html() +
                             '</td><td class="GridViewLabItemStyle" id="tdisExpirable" style="display:none;">' + $rowid.find('#tdisExpirable').html() +
                             '</td><td class="GridViewLabItemStyle" id="tdHSNCode" style="text-align:centre;" >' + $rowid.find("#tdHSNCode").html() +
                             '</td><td class="GridViewLabItemStyle" id="tdMedExpiryDate">' + $rowid.find('#tdMedExpiryDate').html() +
                             '</td><td class="GridViewLabItemStyle" style="text-align:centre;" id="tdUnitType">' + $rowid.find('#tdUnitType').html() +
                             '</td><td class="GridViewLabItemStyle" style="text-align:right;display:none" id="tdActualIssueQty">' + jQuery(this).find('#txtIssueQty').val() +
                             '</td><td class="GridViewLabItemStyle" style="text-align:centre;" id="tdTotalAvlQty">' + $rowid.find("#tdAvlQty").html() +
                             '</td><td class="GridViewLabItemStyle" style="text-align:right" id="tdIssueQty"><input type="text" autocomplete="off" id="txtIssueQty" maxlength="4"  onkeyup="calAmount(this);"  onkeypress="return checkNumeric(event,this);" style="width:54px;text-align:right" value=' + jQuery(this).find('#txtIssueQty').val() + ' />' +
                             '</td><td class="GridViewLabItemStyle" style="text-align:right" id="tdMRP">' + $rowid.find('#tdMRP').html() +
                             '</td><td class="GridViewLabItemStyle" style="text-align:right" id="tdDiscountAmt">' + disc +
                             '</td><td class="GridViewLabItemStyle" style="text-align:right;display:none;" id="tdIGSTTAXPercent">' + parseFloat($rowid.find("#tdIGSTTaxPercent").html()).toFixed(2) +
                             '</td><td class="GridViewLabItemStyle" style="text-align:right" id="tdCGSTTAXPercent">' + parseFloat($rowid.find("#tdCGSTTaxPercent").html()).toFixed(2) +
                             '</td><td class="GridViewLabItemStyle" style="text-align:right" id="tdSGSTTAXPercent">' + parseFloat($rowid.find("#tdSGSTTaxPercent").html()).toFixed(2) +
                             '</td><td class="GridViewLabItemStyle" style="text-align:right;" id="tdAmount"> ' + amt +
                             '</td><td class="GridViewLabItemStyle" style="text-align:right;display:none" id="tdGrossAmount">' + precise_round(parseFloat((parseFloat(jQuery(this).find('#txtIssueQty').val()) * parseFloat(($rowid.find('#tdMRP').html())))), 2) +
                             '</td><td class="GridViewLabItemStyle" style="text-align:right;display:none" id="tdisItemWiseDisc">' + isItemWiseDisc +
                             '</td><td class="GridViewLabItemStyle" style="text-align:centre;display:none" id="tdDiscountPer">' + $.trim($("#txtDiscItem").val()) +
                             '</td><td class="GridViewLabItemStyle" style="text-align:centre;display:none" id="tdStockID">' + $rowid.find('#tdstockID').html() +
                             '</td><td class="GridViewLabItemStyle" style="text-align:centre;display:none" id="tdItemID">' + $rowid.find('#tdItemID').html() +
                             '</td><td class="GridViewLabItemStyle" style="text-align:centre;display:none" id="tdSubCategoryID">' + $rowid.find('#tdSubCategoryID').html() +
                             '</td><td class="GridViewLabItemStyle" style="text-align:centre;display:none" id="tdUnitPrice">' + $rowid.find('#tdUnitPrice').html() +
                             '</td><td class="GridViewLabItemStyle" style="text-align:centre;display:none" id="tdToBeBilled">' + $rowid.find('#tdToBeBilled').html() +
                             '</td><td class="GridViewLabItemStyle" style="text-align:centre;display:none" id="tdIsUsable">' + $rowid.find('#tdIsUsable').html() +
                             '</td><td class="GridViewLabItemStyle" style="text-align:centre;display:none" id="tdType_ID">' + $rowid.find('#tdType_ID').html() +
                             '</td><td class="GridViewLabItemStyle" style="text-align:centre;display:none" id="tdPatientMedicine">' + $rowid.find("#tdMedID").html() +
                             '</td><td class="GridViewLabItemStyle" style="text-align:centre;display:none" id="tdGSTType">' + $rowid.find("#tdGSTType").html() +
                             '</td><td class="GridViewLabItemStyle" style="text-align:center;" id="imgPhRemove"><img id="imgRmv" src="../../Images/Delete.gif" onclick="DeleteRowPh(this);" onmouseover="chngcur()" class="canteenRemove"  style="cursor:pointer;" title="Click To Remove"/></td>'
                            );
                        jQuery("#tb_grdIssueItem").append(newRow);
                        jQuery("#tb_grdIssueItem").show();
                        $('#divSelectedMedicine,#paymentControlDiv,#divAction').show();
                    }

                });
                var count = 0;
                jQuery("#tb_grdIssueItem tr").each(function () {
                    var id = jQuery(this).closest("tr").attr("id");
                    if (id != "IssueItemHeader") {
                        totalAmt += parseFloat(jQuery(this).closest("tr").find("#tdAmount").html());
                        totalDisc += parseFloat(jQuery(this).closest("tr").find("#tdDiscountAmt").html());
                        totalGrossAmt += parseFloat(jQuery(this).closest("tr").find("#tdGrossAmount").html());
                        count += parseFloat(jQuery(this).closest("tr").find("#tdisItemWiseDisc").html());
                    }
                });
                jQuery('#ItemOutput').html('');
                jQuery('#ItemOutput,#btnAddItem,#div_Item').hide();
                jQuery("#lblBillAmount").text(totalAmt);
                jQuery("#lblDiscAmount").text(totalDisc);
                jQuery("#lblGrossAmt").text(totalGrossAmt);
                jQuery('#lblBill,#btnSave,#lblBillAmount,#div_Issue').show();
                // updateTotalAmount(jQuery('#lblGrossAmt').text(), jQuery('#lblBillAmount').text(), jQuery("#lblDiscAmount").text(), "0");
                $("#ddlPanelCompany").attr('disabled', 'disabled');
                //AddAmount();
                // jQuery("#<%=txtSearch.ClientID%>").focus();
                $("#spnTotalMedicine").text(jQuery("#tb_grdIssueItem tr").length - 1);
                $('#canteenItem').focus();
                showChkDisc(count);
            }

            $addBillAmount({
                panelId: '<%=Resources.Resource.DefaultPanelID%>',
                billAmount: totalGrossAmt,
                disCountAmount: totalDisc,
                isReceipt: 1,
                patientAdvanceAmount: 0,
                autoPaymentMode: false,
                minimumPayableAmount: totalGrossAmt,
                panelAdvanceAmount: 0,
                disableDiscount: false,
                disableCredit: true,
                refund: { status: false }
            }, function () { });
        }
        function showChkDisc(count) {


        }
        function precise_roundoff(num, decimals) {
            return Math.round(num * Math.pow(10, decimals)) / Math.pow(10, decimals);
        }
        function DeleteRowPh(rowid) {
            var amt = 0; var totalDisc = 0; var totalGrossAmt = 0, count = 0;
            var row = rowid;
            jQuery(row).closest('tr').remove();
            jQuery("#tb_grdIssueItem tr").each(function () {
                var id = jQuery(this).closest("tr").attr("id");
                if (id != "IssueItemHeader") {
                    amt += parseFloat(jQuery(this).closest("tr").find("#tdAmount").html());
                    totalDisc += parseFloat(jQuery(this).closest("tr").find("#tdDiscountAmt").html());
                    totalGrossAmt += parseFloat(jQuery(this).closest("tr").find("#tdGrossAmount").html());
                    count += parseFloat(jQuery(this).closest("tr").find("#tdisItemWiseDisc").html());
                }
            });
            jQuery("#lblBillAmount").text(amt);
            jQuery("#lblDiscAmount").text(totalDisc);
            jQuery("#lblGrossAmt").text(totalGrossAmt);
            if (jQuery("#tb_grdIssueItem tr").length == "1") {
                jQuery('#tb_grdIssueItem,#lblBill,#btnSave,#lblBillAmount,#div_Issue,#divSave').hide();
                $("#ddlPanelCompany").removeAttr('disabled');
                $("#grdPaymentMode tr:not(#Header)").remove();
                $('#grdPaymentMode').removeAttr('disabled').hide();

            }
            else {
                jQuery('#lblBill,#btnSave,#lblBillAmount').show();
            }
            // updateTotalAmount(jQuery('#lblGrossAmt').text(), jQuery('#lblBillAmount').text(), jQuery("#lblDiscAmount").text(), "0");
            if (jQuery("#tb_grdIssueItem tr").length > 1) {
                jQuery('#rdoHospitalPatient,#rdoGeneral,#rdoIPD,#btnCanteenSearch,#btnOldPatient').attr('disabled', 'disabled');
            }
            else {
                jQuery('#rdoHospitalPatient,#rdoGeneral,#rdoIPD,#btnCanteenSearch,#btnOldPatient').removeAttr('disabled');
            }
            if ($("#spnCanteenIssue").length > "0") {

            }
            //if (jQuery("#tb_grdIssueItem tr").length > "1")
            //    AddAmount();

            $("#spnTotalMedicine").text(jQuery("#tb_grdIssueItem tr").length - 1);
            showChkDisc(count);
        }
        function chngcur() {
            document.body.style.cursor = 'pointer';
        }
    </script>
    <script type="text/javascript">
        function patientGeneralMaster() {
            var dataGen = new Array();
            var objGen = new Object();
            objGen.Title = jQuery("#ddlTitle option:selected").text();
            objGen.Name = jQuery.trim(jQuery("#txtGenName").val());
            if (jQuery.trim(jQuery("#txtGenAge").val()) != "")
                objGen.Age = jQuery.trim(jQuery("#txtGenAge").val()) + " " + jQuery("#ddlAge option:selected").text();
            else
                objGen.Age = "";

            //if (jQuery.trim(jQuery("#txtGenName").val()) == "") {
            //    objGen.Name="Canteen Sale";
            //}
            //else{
            //    objGen.Name = jQuery.trim(jQuery("#txtGenName").val());
            //}

            //if (jQuery.trim(jQuery("#txtGenAge").val()) != "") {
            //    objGen.Age = jQuery.trim(jQuery("#txtGenAge").val()) + " " + jQuery("#ddlAge option:selected").text();
            //}
            //else {
            //    objGen.Age = "0 YRS";
            //}

            objGen.Address = jQuery.trim(jQuery("#txtGenAddress").val());
            objGen.Gender = jQuery("#rdoGenGender input:checked").val();
            objGen.ContactNo = jQuery("#txtGenContact").val();
            dataGen.push(objGen);
            return dataGen;
        }
        function patientmedicalhistory() {
            var dataPMH = new Array();
            var objPMH = new Object();
            if ((jQuery("#rdoHospitalPatient").is(':checked')) || (jQuery("#rdoIPD").is(':checked'))) {
                objPMH.Patient_ID = jQuery.trim(jQuery("#spnPatientID").text());
                objPMH.Age = jQuery.trim(jQuery("#spnAge").text().split('/')[0])
                objPMH.Doctor_ID = jQuery.trim(jQuery("#ddlDoctor").val());
                objPMH.Panel_ID = jQuery.trim(jQuery("#ddlPanelCompany").val());
                objPMH.ReferedBy = jQuery.trim(jQuery("#ddlDoctor").val());
            }
            else {
                objPMH.Patient_ID = "CASH003";
                objPMH.Doctor_ID = "";
                objPMH.Panel_ID = '<%=Resources.Resource.DefaultPanelID%>';
                objPMH.ReferedBy = "";
            }
            objPMH.HashCode = jQuery.trim(jQuery("#txtHash").val());
            objPMH.patient_type = jQuery.trim(jQuery("#spnHospPatientType").text());
            dataPMH.push(objPMH);
            return dataPMH;
        }
        var $isReceipt = true; //'<%=Resources.Resource.IsReceipt%>' == '1' ? true : false;
        var hashCode=   jQuery('#txtHash').val();
        function LedgerTransaction() {
            var data$LT = new Array();
            var obj$LT = new Object(); 
                $getPaymentDetails(function (payment) { 
                    obj$LT = {
                            PanelID: '<%=Resources.Resource.DefaultPanelID %>',
                            NetAmount: payment.netAmount,
                            GrossAmount: payment.billAmount,
                            DiscountReason: payment.discountReason,
                            DiscountApproveBy: payment.approvedBY,
                            DiscountOnTotal: payment.discountAmount,
                            RoundOff: payment.roundOff,
                            GovTaxPer: 0,
                            GovTaxAmount: 0,
                            IPNo: '',//for do latar
                            Adjustment: $isReceipt ? payment.adjustment : 0,
                            UniqueHash: hashCode,
                        }
                })
            data$LT.push(obj$LT);
            return data$LT;
            }

        function LedgerTransactionDetail() {
            var count = 0;
            jQuery("#tb_grdIssueItem tr").each(function () {
                var id = jQuery(this).closest("tr").attr("id");
                if (id != "IssueItemHeader") {
                    count += parseFloat(jQuery(this).closest("tr").find("#tdisItemWiseDisc").html());
                }
            });

            var dataLTDt = new Array();
            var ObjLdgTnxDt = new Object();
            jQuery("#tb_grdIssueItem tr").each(function () {
                var id = jQuery(this).attr("id");
                var $rowid = jQuery(this).closest("tr");
                if (id != "IssueItemHeader") {
                    ObjLdgTnxDt.ItemID = jQuery.trim($rowid.find("#tdItemID").text());
                    ObjLdgTnxDt.StockID = jQuery.trim($rowid.find("#tdStockID").text());
                    ObjLdgTnxDt.SubCategoryID = jQuery.trim($rowid.find("#tdSubCategoryID").text());
                    ObjLdgTnxDt.Rate = jQuery.trim($rowid.find("#tdMRP").text());
                    ObjLdgTnxDt.Quantity = jQuery.trim($rowid.find("#txtIssueQty").val());
                    ObjLdgTnxDt.ItemName = ($rowid.find("#tdItemName").text()) + " (Batch : " + ($rowid.find("#tdBatchNumber").text()) + ")";
                    ObjLdgTnxDt.medExpiryDate = jQuery.trim($rowid.find("#tdMedExpiryDate").text());
                    ObjLdgTnxDt.ToBeBilled = jQuery.trim($rowid.find("#tdToBeBilled").text());
                    ObjLdgTnxDt.IsReusable = jQuery.trim($rowid.find("#tdIsUsable").text());
                    var DiscAmt = 0;
                    var DiscountPercentage = 0;
                    if (count > 0) {
                        ObjLdgTnxDt.DiscAmt = jQuery.trim($rowid.find("#tdDiscountAmt").text());
                        ObjLdgTnxDt.DiscountPercentage = jQuery.trim($rowid.find("#tdDiscountPer").text());
                        ObjLdgTnxDt.Amount = parseFloat($rowid.find("#tdAmount").text());
                    }

                    else {


                        ObjLdgTnxDt.DiscountPercentage = DiscountPercentage;
                        var DiscAmount = ((($.trim($rowid.find("#tdMRP").text())) * ($.trim($rowid.find("#txtIssueQty").val())) * (DiscountPercentage)) / 100);
                        ObjLdgTnxDt.DiscAmt = DiscAmount;
                        ObjLdgTnxDt.Amount = parseFloat((($.trim($rowid.find("#tdMRP").text())) * ($.trim($rowid.find("#txtIssueQty").val()))) - (DiscAmount));
                    }

                    // Add new on 29-06-2017 - For GST
                    ObjLdgTnxDt.HSNCode = jQuery.trim($rowid.find("#tdHSNCode").text());
                    ObjLdgTnxDt.IGSTPercent = jQuery.trim($rowid.find("#tdIGSTTAXPercent").text());
                    ObjLdgTnxDt.CGSTPercent = jQuery.trim($rowid.find("#tdCGSTTAXPercent").text());
                    ObjLdgTnxDt.SGSTPercent = jQuery.trim($rowid.find("#tdSGSTTAXPercent").text());
                    ObjLdgTnxDt.GSTType = jQuery.trim($rowid.find("#tdGSTType").text());
                    //

                    dataLTDt.push(ObjLdgTnxDt);
                    ObjLdgTnxDt = new Object();
                }
            });
            return dataLTDt;
        }

        function savePaymentDetail() {
            var paymentDetail = [];
            $getPaymentDetails(function (paymentDetails) {
            $(paymentDetails.paymentDetails).each(function () {
                paymentDetail.push({
                    PaymentMode: this.PaymentMode,
                    PaymentModeID: this.PaymentModeID,
                    S_Amount: this.S_Amount,
                    S_Currency: this.S_Currency,
                    S_CountryID: this.S_CountryID,
                    BankName: this.BankName,
                    RefNo: this.RefNo,
                    BaceCurrency: this.BaceCurrency,
                    C_Factor: this.C_Factor,
                    Amount: this.Amount,
                    S_Notation: this.S_Notation,
                    PaymentRemarks: paymentDetails.paymentRemarks,
                    swipeMachine: this.swipeMachine,
                    currencyRoundOff: paymentDetails.currencyRoundOff / paymentDetails.paymentDetails.length
                });
            });
            }); 
            return paymentDetail
        }
        function SalesDetails() {
            var dataSDt = new Array();
            var ObjSDt = new Object();

            jQuery("#tb_grdIssueItem tr").each(function () {
                var id = jQuery(this).attr("id");
                var $rowid = jQuery(this).closest("tr");
                if (id != "IssueItemHeader") {
                    ObjSDt.StockID = jQuery.trim($rowid.find("#tdStockID").text());
                    ObjSDt.SoldUnits = jQuery.trim($rowid.find("#txtIssueQty").val());
                    ObjSDt.PerUnitBuyPrice = jQuery.trim($rowid.find("#tdUnitPrice").text());
                    ObjSDt.PerUnitSellingPrice = jQuery.trim($rowid.find("#tdMRP").text());
                    ObjSDt.ItemID = jQuery.trim($rowid.find("#tdItemID").text());
                    ObjSDt.ToBeBilled = jQuery.trim($rowid.find("#tdToBeBilled").text());
                    ObjSDt.IsReusable = jQuery.trim($rowid.find("#tdIsUsable").text());
                    ObjSDt.Type_ID = jQuery.trim($rowid.find("#tdType_ID").text());
                    dataSDt.push(ObjSDt);
                    ObjSDt = new Object();
                }
            });
            return dataSDt;
        }

        function chkValdation() {
            var con = 0;
            if (jQuery("#rdoHospitalPatient").is(':checked')) {
                if (jQuery.trim(jQuery("#spnPatientID").text()) == "") {
                    jQuery('#spnMsg').text('Please Enter Valid MR No.');
                    jQuery('#txtMRNo').focus();
                    con = 1;
                    return false;
                }
                if (jQuery("#ddlDoctor option:selected").text() == "Select") {
                    jQuery('#spnMsg').text('Please Select Doctor');
                    jQuery('#ddlDoctor').focus();
                    con = 1;
                    return false;
                }
            }
            else if (jQuery("#rdoIPD").is(':checked')) {
                if (jQuery.trim(jQuery("#txtIPDNo").val()) == "") {
                    jQuery('#spnMsg').text('Please Enter Valid IPD No.');
                    jQuery('#txtIPDNo').focus();
                    con = 1;
                    return false;
                }
                if (jQuery.trim(jQuery("#spnIPDNo").text()) == "") {
                    jQuery('#spnMsg').text('Please Enter Valid IPD No.');
                    jQuery('#txtIPDNo').focus();
                    con = 1;
                    return false;
                }
                if (jQuery("#ddlDoctor option:selected").text() == "Select") {
                    jQuery('#spnMsg').text('Please Select Doctor');
                    jQuery('#ddlDoctor').focus();
                    con = 1;
                    return false;
                }
            }
            else {
                //if (jQuery.trim(jQuery("#txtGenName").val()) == "") {
                //    jQuery('#spnMsg').text('Please Enter Name');
                //    jQuery('#txtGenName').focus();
                //    con = 1;
                //    return false;
                //}
                //if (jQuery.trim(jQuery("#txtGenAge").val()) == "") {
                //    jQuery('#spnMsg').text('Please Enter Valid Age');
                //    jQuery('#txtGenAge').focus();
                //    con = 1;
                //    return false;
                //}
                //if (jQuery.trim(jQuery("#txtGenAddress").val()) == "") {
                //    jQuery('#spnMsg').text('Please Enter Address');
                //    jQuery('#txtGenAddress').focus();
                //    con = 1;
                //    return false;
                //}
                if ((jQuery.trim(jQuery("#txtGenContact").val()).length < "10") && (jQuery.trim(jQuery("#txtGenContact").val()) != "")) {
                    jQuery('#spnMsg').text('Please Enter Valid Contact No.');
                    jQuery('#txtGenContact').focus();
                    con = 1;
                    return false;
                }

                if ($('#txtGenName').val() == "")
                {
                    modelAlert('Please enter a name');
                    con = 1;
                    return false;
                }
            }
            if ($('#txtDisAmount').val() > 0 || $('#txtDisPercent').val() > 0) {
                if ($("input[id*=txtDiscReason]").val() == "") {
                    $('#spnMsg').text('Please Enter Discount Reason');
                    $("input[id*=txtDiscReason]").focus();
                    con = 1;
                    return false;
                }
                if ($('select[id*=ddlApproveBy]').val() == "0") {
                    $('#spnMsg').text('Please Select Approve By');
                    $('select[id*=ddlApproveBy]').focus();
                    con = 1;
                    return false;
                }
            }

            if (($('#txtNetAmount').val() > 0) && ($('select[id*=ddlPaymentMode]').val() != "4")) {
                if ($('#grdPaymentMode tr').length == "1") {
                    $('#spnMsg').text('Please Add Amount');
                    con = 1;
                    $('#btnAdd').focus();
                    return false;
                }
            }
            if (($('#txtNetAmount').val() > 0) && ($('select[id*=ddlPaymentMode]').val() != "4")) {
                if ($('#grdPaymentMode tr').length == "1") {
                    $('#spnMsg').text('Please Add Amount');
                    con = 1;
                    $('#btnAdd').focus();
                    return false;
                }
            }
            jQuery("#tb_grdIssueItem tr").each(function () {
                var id = jQuery(this).closest("tr").attr("id");
                if (id != "IssueItemHeader") {
                    var issueQty = jQuery(this).closest("tr").find("#txtIssueQty").val();
                    if (isNaN(issueQty)) issueQty = 0;
                    if (issueQty == "" || issueQty == "0") {
                        $('#spnMsg').text('Please Enter Valid Issue Qty.');
                        jQuery(this).closest("tr").find("#txtIssueQty").focus();
                        con = 1;
                        return false;
                    }
                }
            });
            var amt = 0;
            $("#grdPaymentMode tr").each(function () {
                var id = $(this).closest("tr").attr("id");
                if (id != "Header") {
                    amt += parseFloat($(this).closest("tr").find("#tdPaidAmount").html());
                }
            });
            //if (parseFloat($.trim($("#txtTotalPaidAmount").val())) != amt) {
            //    $('#spnMsg').text("Please Pay Full Amount");
            //    con = 1;
            //    return false;
            //}
            if (con == "1") {
                return false;
            }
            return true;
        }
    </script>
    <script type="text/javascript">
        jQuery(function () {
            jQuery("#btnSave").click(function () {
                jQuery("#btnSave").attr('disabled', 'disabled').val("Submitting...");
                if (chkValdation()) {
                    var resultGeneral = patientGeneralMaster();
                    var resultPMH = patientmedicalhistory();
                    var resultLT = LedgerTransaction();
                    var resultLTD = LedgerTransactionDetail();
                    var resultSalesDetails = SalesDetails();
                    var resultPaymentDetail = savePaymentDetail();
                    var patientType = $('input[name=group1]:checked').val();
                    var DeptLedgerNo = $("#lblDeptLedgerNo").val();

                    if (resultPaymentDetail.length < 1 && '<%=Resources.Resource.IsReceipt %>' == '1') {
                        modelAlert('Please Select Payment Details', function () {
                        });
                        jQuery("#btnSave").removeAttr('disabled').val("Save");
                        return false;
                    }
               

                    var contactNo = ""; var PName = "";
                    if ($('input[name=group1]:checked').val() != "2") {
                        contactNo = $.trim($("#spnContactNo").text());
                        PName = $.trim($("#spnPName").text());
                    }
                    else {
                        contactNo = $.trim($("#txtGenContact").val());
                        PName = $("#ddlTitle").val() + " " + $.trim($("#txtGenName").val());
                    }
                    jQuery.ajax({
                        url: "Services/WebService.asmx/SaveCanteen",
                        data: JSON.stringify({ PMH: resultPMH, LT: resultLT, LTD: resultLTD, SalesDetails: resultSalesDetails, generalPatient: resultGeneral, PaymentDetail: resultPaymentDetail, patientType: patientType, DeptLedgerNo: DeptLedgerNo, contactNo: contactNo, PName: PName }),
                        type: "Post",
                        contentType: "application/json; charset=utf-8",
                        timeout: "120000",
                        dataType: "json",
                        success: function (result) {
                            OutPut = result.d;
                            if (result.d == "0") {
                                $("#spnMsg").text('Error occurred, Please contact administrator');
                                jQuery("#btnSave").attr('disabled', false).val("Save");
                            }
                            else if (result.d.indexOf("#") != -1) {
                                window.open('../common/GSTCanteenReceipt.aspx?LedTnxNo=' + OutPut.split('#')[0] + '&OutID=' + OutPut.split('#')[1] + '&DeptLedgerNo=' + OutPut.split('#')[2] + '&IsBill=1&Duplicate=0');
                                $("#spnMsg").text('Record Saved Successfully');
                                jQuery("#txtGenName").focus();
                                clearControl();
                                location.reload();

                            }
                            else {
                                //for (var i = 0; i < OutPut.length; i++) {
                                //    var Index = OutPut[i]["itemIndex"];
                                //    $('#tb_grdIssueItem tbody tr:eq(' + Index + ') td').css("background-color", "#FF0000");
                                //}
                                var titleText = 'Stock already issued, Available Stock ' + result.d.split('$')[1];
                                $('#tb_grdIssueItem tbody tr:eq(' + result.d.split('$')[0] + ') td').css("background-color", "#FF0000");
                                $('#tb_grdIssueItem tbody tr:eq(' + result.d.split('$')[0] + ') td').attr('title', titleText);
                                jQuery("#spnMsg").text(titleText);
                                //clearControl();
                                jQuery("#btnSave").attr('disabled', false).val("Save");
                                return;
                            }
                        },
                        error: function (xhr, status) {
                            clearControl();
                            $("#spnMsg").text('Error occurred, Please contact administrator');
                        }
                    });
                }
                else {
                    jQuery("#btnSave").removeAttr('disabled').val("Save");
                }
            });
        });
        function clearControl() {
            jQuery("#btnSave").attr('disabled', false).val("Save");
            jQuery("#tb_grdIssueItem tr:not(:first)").remove();
            jQuery('#lblBillAmount,#lblGrossAmt').text('0');
            jQuery("#ItemOutput").html('');
            jQuery('#tb_grdIssueItem,#lblBill,#lblBillAmount,#ItemOutput,#btnAddItem,#lblGrossAmt').hide();
            jQuery("#rdoTypeItem").prop("checked", true);
            jQuery("#txtGenAddress,#txtGenContact,#txtGenAge").val('');

            // bindItem();
            bindHashCode();
            //jQuery("#pnlOPD").show();
            //jQuery("#pnlGeneral,#pnlAllInfo,#btnSave,#div_Issue,#pnlInfo,#txtIPDNo,#divSave").hide();
            jQuery("#txtMRNo,#txtGenName,#txtGenAge,#txtGenAddress,#txtGenContact,#txtIPDNo").val('');
            jQuery("#ddlDoctor,#ddlTitle,#ddlAge").prop('selectedIndex', 0)
            jQuery("#ddlPanelCompany").val('<%=Resources.Resource.DefaultPanelID %>');
            jQuery('#<%=rdoGenGender.ClientID%> :radio[value="Male"]').attr({ checked: true, disabled: false });
            AutoGender();
            jQuery("#rdoHospitalPatient,#rdoGeneral,#rdoIPD").removeAttr('disabled');
            jQuery("#btnCanteenSearch,#btnOldPatient").removeAttr('disabled');
            $("#grdPaymentMode tr:not(#Header)").remove();
            $('#grdPaymentMode').removeAttr('disabled').hide();
            $("#div_Items").empty();
        }
    </script>
    <script type="text/javascript">
        function bindPanel() {
            jQuery.ajax({
                url: "../Common/CommonService.asmx/bindPanel",
                data: '{}',
                type: "Post",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    panel = jQuery.parseJSON(result.d);
                    for (i = 0; i < panel.length; i++) {
                        jQuery("#ddlPanelCompany").append(jQuery("<option></option>").val(panel[i].Panel_ID).html(panel[i].Company_Name));
                    }
                    jQuery("#ddlPanelCompany").val('<%=Resources.Resource.DefaultPanelID %>');
                },
                error: function (xhr, status) {
                }
            });
        }

        jQuery(function () {
            bindHashCode();
            LoadDetail();
        });
        function bindHashCode() {
            jQuery('#txtHash').val('');
            jQuery.ajax({
                url: "../Common/CommonService.asmx/bindHashCode",
                data: '{}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    jQuery('#txtHash').val(result.d);
                },
                error: function (xhr, status) {
                }
            });
        }
    </script>
    <script type="text/javascript">
        function LoadDetail() {
            var strItem = jQuery('#<%=lstItems.ClientID %>').val();
            if (strItem != null) {
                var ItemID = strItem.split('#')[0];
                var DeptLedgerNo = '<%=Session["DeptLedgerNo"].ToString()%>';
                jQuery.ajax({
                    url: "Services/WebService.asmx/BindMedicineDetail",
                    data: '{ ItemID: "' + ItemID + '",DeptLedgerNo: "' + DeptLedgerNo + '"}',
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    async: false,
                    dataType: "json",
                    success: function (result) {
                        Data = jQuery.parseJSON(result.d);
                        if (Data.length > 0) {
                            $("#div_Items").empty();
                            var table = "<table id='tblResult' class='GridViewStyle' style='border:1px solid;border-color:#2C5A8B;overflow:scroll;height:20px;'><tr ><th class='GridViewHeaderStyle' style='width:60px;' >Batch&nbsp;No.</th> <th class='GridViewHeaderStyle' style='width:60px;' >C.&nbsp;Factor</th> <th class='GridViewHeaderStyle' style='width:30px;'>MRP</th> <th class='GridViewHeaderStyle' style='width:60px;'>Unit&nbsp;MRP</th>  </tr><tbody>";
                            for (var i = 0; i < Data.length; i++) {
                                var row = "<tr>";
                                row += "<td colspan='1' class='GridViewItemStyle' style='width:90px;background-color:#2C5A8B;color:White;font-weight:bold;text-align:center'>" + Data[i].BatchNumber + "</td>";
                                row += "<td colspan='1' class='GridViewItemStyle' style='width:60px;background-color:#2C5A8B;color:White;font-weight:bold;text-align:right'>" + Data[i].ConversionFactor + "</td>";
                                row += "<td colspan='1' class='GridViewItemStyle' style='width:60px;background-color:#2C5A8B;color:White;font-weight:bold;text-align:right'>" + Data[i].MajorMRP + "</td>";
                                row += "<td colspan='1' class='GridViewItemStyle' style='width:60px;background-color:#2C5A8B;color:White;font-weight:bold;text-align:right'>" + Data[i].MRP + "</td>";
                                row += "</tr>";
                                table += row;
                            }
                            table += "</tbody></table>";
                            $("#div_Items").append(table);
                        }
                    },
                    error: function (xhr, status) {
                        modelAlert("Error ");
                    }
                });
            }
        }
    </script>
    <script type="text/javascript">
        function MoveUpAndDownText(textbox2, listbox2) {
            var f = document.theSource;
            var listbox = listbox2;
            var textbox = textbox2;
            if (event.keyCode == 13) {
                textbox.value = "";
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
            LoadDetail();
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
                var m;
                for (m = 0; m < listbox.length; m++) {
                    suggestion = listbox.options[m].text.toString();
                    suggestion = suggestion.substring(0, level).toLowerCase();
                    if (soFarLeft == suggestion) {
                        listbox.options[m].selected = true;
                        matched = true;
                        break;
                    }
                }
                if (matched && level < soFar.length) { level++; suggestName(textbox, listbox, level) }
            }
            LoadDetail();
        }
    </script>
    <script type="text/javascript">
        function bindItem() {
            jQuery('#lstItems option').remove();
            jQuery.ajax({
                type: "POST",
                url: "Services/WebService.asmx/bindItem",
                data: "{}",
                contentType: "application/json;charset=UTF-8",
                dataType: "json",
                async: false,
                timeout: 120000,
                success: function (result) {
                    var item = jQuery.parseJSON(result.d);
                    if (item != null) {
                        for (var i = 0; i < item.length; i++) {
                            jQuery('#lstItems').append(jQuery("<option></option>").val(item[i].ItemID).html(item[i].ItemName));
                        }
                    }
                },
                error: function (xhr, status) {
                }
            });
        }
        function ValidDots() {
            if ((jQuery("#<%=txtTransferQty.ClientID%>").val().charAt(0) == ".")) {
                jQuery("#<%=txtTransferQty.ClientID%>").val('');
                return false;
            }
            return true;
        }
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
        function CheckQty(Qty) {
            var Amt = jQuery(Qty).val();
            if (Amt.match(/[^0-9]/g)) {
                Amt = Amt.replace(/[^0-9]/g, '');
                jQuery(qty).val(number(Amt));
                return;
            }
            if (Amt.charAt(0) == "0") {
                jQuery(Qty).val(Number(Amt));
            }
            if (Amt.indexOf('.') != -1) {
                var DigitsAfterDecimal = 2;
                var valIndex = Amt.indexOf(".");
                if (valIndex > "0") {
                    if (Amt.length - (Amt.indexOf(".") + 1) > DigitsAfterDecimal) {
                        modelAlert("Only " + DigitsAfterDecimal + " Digits Are Allowed After Decimal");
                        jQuery(Qty).val(jQuery(Qty).val().substring(0, (jQuery(Qty).val().length - 1)));
                        return false;
                    }
                }
            }
            if (Amt == "") {
                jQuery(Qty).val('1');
            }
        }
    </script>
    <script type="text/javascript">
        function AutoGender() {
            if (jQuery('#rdoGeneral').is(':checked')) {
                var ddltitle = document.getElementById('<%=ddlTitle.ClientID%>');
                var ddltxt = ddltitle.options[ddltitle.selectedIndex].value;
                if (ddltxt == "Mr.") {
                    jQuery('#<%=rdoGenGender.ClientID%> :radio[value="Male"]').attr({ checked: true, disabled: true });
                    jQuery('#<%=rdoGenGender.ClientID%> :radio[value="Female"]').attr('disabled', true);
                }
                else if (ddltxt == "Mrs.") {
                    jQuery('#<%=rdoGenGender.ClientID%> :radio[value="Female"]').attr({ checked: true, disabled: true });
                    jQuery('#<%=rdoGenGender.ClientID%> :radio[value="Male"]').attr('disabled', true);

                }
                else if (ddltxt == "Miss." || ddltxt == "Baby" || ddltxt == "Madam") {
                    jQuery('#<%=rdoGenGender.ClientID%> :radio[value="Female"]').attr({ checked: true, disabled: true });
                    jQuery('#<%=rdoGenGender.ClientID%> :radio[value="Male"]').attr('disabled', true);

                }
                else if (ddltxt == "Master") {
                    jQuery('#<%=rdoGenGender.ClientID%> :radio[value="Male"]').attr({ checked: true, disabled: true });
                    jQuery('#<%=rdoGenGender.ClientID%> :radio[value="Female"]').attr('disabled', true);
                }
                else if (ddltxt == "B/O") {
                    jQuery('#<%=rdoGenGender.ClientID%> :radio[value="Male"]').attr('disabled', false);
                    jQuery('#<%=rdoGenGender.ClientID%> :radio[value="Female"]').attr('disabled', false);
                }
                else if (ddltxt == "Dr." || ddltxt == "Er." || ddltxt == "Nana" || ddltxt == "Alhaji" || ddltxt == "Hajia" || ddltxt == "Prof.") {
                    jQuery('#<%=rdoGenGender.ClientID%> :radio[value="Male"]').attr('disabled', false);
                    jQuery('#<%=rdoGenGender.ClientID%> :radio[value="Female"]').attr('disabled', false);
                }
                else {
                    jQuery('#<%=rdoGenGender.ClientID%>').attr('disabled', false);
                    jQuery('#<%=rdoGenGender.ClientID%> :radio[value="Male"]').attr('checked', true);
                }
    if (ddltxt == "B/O") {
        jQuery('#<%=ddlAge.ClientID%>').prop("selectedIndex", 2);
        jQuery("#<%=ddlAge.ClientID%> option[value='YRS']").attr("disabled", true);
        jQuery("#<%=ddlAge.ClientID%> option[value='MONTH(S)']").attr("disabled", false);
        jQuery("#<%=ddlAge.ClientID%> option[value='DAYS(S)']").attr("disabled", false);
    }
    else if (ddltxt == "Baby" || ddltxt == 'Master') {
        jQuery('#<%=ddlAge.ClientID%>').prop("selectedIndex", 1);
                    jQuery("#<%=ddlAge.ClientID%> option[value='YRS']").attr("disabled", false);
                    jQuery("#<%=ddlAge.ClientID%> option[value='MONTH(S)']").attr("disabled", false);
                    jQuery('#<%=ddlAge.ClientID%> option:contains("DAYS(S)")').attr('disabled', false);
                }
                else {
                    jQuery('#<%=ddlAge.ClientID%>').prop("selectedIndex", 0);
                    jQuery("#<%=ddlAge.ClientID%> option[value='YRS']").attr("disabled", false);
                    jQuery("#<%=ddlAge.ClientID%> option[value='MONTH(S)']").attr("disabled", true);
                    jQuery('#<%=ddlAge.ClientID%> option:contains("DAYS(S)")').attr('disabled', true);
                }
            var age = jQuery('#<%=ddlAge.ClientID%>').val();
                if (age == "YRS") {
                    validateageyrs();
                }
                else if (age == "MONTH(S)") {
                    validatemonth();
                }
                else
                    validatedays();
            }
        }
        function validateageyrs() {
            var MaxValue = 161;
            jQuery('#<%=txtGenAge.ClientID %>').keyup(function (e) {
                if (jQuery(this).val() >= MaxValue && jQuery('#<%=ddlAge.ClientID%>').val() == "YRS") {
                    jQuery("#spnMsg").text('Please Enter Valid Age In YRS');
                    jQuery('#<%=txtGenAge.ClientID %>').val('');
                    jQuery('#<%=txtGenAge.ClientID %>').focus();
                }
            });
            jQuery("#spnMsg").text('');
        }
        function validatemonth() {
            var MaxValue = 13;
            jQuery('#<%=txtGenAge.ClientID %>').keyup(function (e) {
                if (jQuery(this).val() >= MaxValue && jQuery('#<%=ddlAge.ClientID%>').val() == "MONTH(S)") {
                    jQuery("#spnMsg").text('Please Enter Valid Age In Month');
                    jQuery('#<%=txtGenAge.ClientID %>').val('');
                    jQuery('#<%=txtGenAge.ClientID %>').focus();
                }
            });
            jQuery("#spnMsg").text('');
        }
        function validatedays() {
            var MaxValue = 32;
            jQuery('#<%=txtGenAge.ClientID %>').keyup(function (e) {
                if (jQuery(this).val() >= MaxValue && jQuery('#<%=ddlAge.ClientID%>').val() == "DAYS(S)") {
                    jQuery("#spnMsg").text('Please Enter Valid Age In days');
                    jQuery('#<%=txtGenAge.ClientID %>').val('');
                    jQuery('#<%=txtGenAge.ClientID %>').focus();
                }
            });
            jQuery("#spnMsg").text('');
        }
        function validateAge() {
            var MaxValueMonth = 13;
            var MaxValueYrs = 161;
            var MaxValueDay = 32
            if (jQuery('#<%=txtGenAge.ClientID %>').val() >= MaxValueMonth && jQuery('#<%=ddlAge.ClientID%>').val() == "MONTH(S)") {
                jQuery("#spnMsg").text('Please Enter Valid Age In Month');
                jQuery('#<%=txtGenAge.ClientID %>').val('');
                jQuery('#<%=txtGenAge.ClientID %>').focus();
            }
            else if (jQuery('#<%=txtGenAge.ClientID %>').val() >= MaxValueYrs && jQuery('#<%=ddlAge.ClientID%>').val() == "YRS") {
                jQuery("#spnMsg").text('Please Enter Valid Age In YRS');
                jQuery('#<%=txtGenAge.ClientID %>').val('');
                jQuery('#<%=txtGenAge.ClientID %>').focus();
            }

            else if (jQuery('#<%=txtGenAge.ClientID %>').val() >= MaxValueDay && jQuery('#<%=ddlAge.ClientID%>').val() == "DAYS(S)") {
                jQuery("#spnMsg").text('Please Enter Valid Age In Days');
                jQuery('#<%=txtGenAge.ClientID %>').val('');
                jQuery('#<%=txtGenAge.ClientID %>').focus();
            }
            else {
            }
}
function ValidateAge() {
    if (Number(jQuery('#<%=txtGenAge.ClientID %>').val()) > 150) {
        jQuery('#<%=txtGenAge.ClientID %>').val('');
        modelAlert('Invalid Age');
    }
}
    </script>
    <script type="text/javascript">
        function chkPatientType() {
            if (jQuery("#rdoHospitalPatient").is(':checked')) {
                jQuery("#pnlOPD,#txtMRNo,#btnOldPatient,#btnMedicine,#txtPopUpMRNo").show();
                jQuery("#spnType").text('MR No. : ');
                jQuery("#spnPatientType").text('MR No. : ').show();
                jQuery("#pnlGeneral,#pnlAllInfo,#pnlInfo,#txtIPDNo,#txtPhIPDNo").hide();
                jQuery("#txtMRNo").focus();
            }
            else if (jQuery("#rdoIPD").is(':checked')) {
                jQuery("#txtMRNo,#btnOldPatient").hide();
                jQuery("#txtIPDNo,#pnlOPD,#btnMedicine,#txtPhIPDNo").show();
                jQuery("#spnType").text('IPD No. : ');
                jQuery("#spnPatientType").text('IPD No. : ').show();
                jQuery("#pnlGeneral,#pnlAllInfo,#pnlInfo,#txtPopUpMRNo").hide();
                jQuery("#txtIPDNo").focus();
            }
            else {
                jQuery("#pnlGeneral,#pnlAllInfo").show();
                jQuery("#pnlOPD,#pnlInfo,#btnOldPatient,#btnMedicine").hide();
                jQuery("#txtGenName").focus();
            }
            jQuery("#txtMRNo,#txtGenName,#txtGenAge,#txtGenAddress,#txtGenContact,#txtIPDNo").val('');
            jQuery("#ddlDoctor,#ddlTitle,#ddlAge").prop('selectedIndex', 0)
            jQuery("#ddlPanelCompany").val('<%=Resources.Resource.DefaultPanelID %>');
            jQuery('#<%=rdoGenGender.ClientID%> :radio[value="Male"]').attr({ checked: true, disabled: false });
            AutoGender();
            jQuery("#spnMsg").text('');
            jQuery('#tb_grdIssueItem,#lblBill,#lblBillAmount,#ItemOutput,#btnAddItem,#btnSave,#divSave,#div_Item,#div_Issue').hide();
            //clearControl();
            jQuery("#tb_grdIssueItem tr:not(:first)").remove();
            clearPaymentControl();
        }
        function check(sender, e) {
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
            formatBox = document.getElementById(sender.id);
            strLen = sender.value.length;
            strVal = sender.value;
            hasDec = false;
            e = (e) ? e : (window.event) ? event : null;
            if (e) {
                var charCode = (e.charCode) ? e.charCode :
                            ((e.keyCode) ? e.keyCode :
                            ((e.which) ? e.which : 0));
                if ((charCode == 45)) {
                    for (var i = 0; i < strLen; i++) {
                        hasDec = (strVal.charAt(i) == '-');
                        if (hasDec)
                            return false;
                    }
                }
                if (charCode == 46) {
                    for (var i = 0; i < strLen; i++) {
                        hasDec = (strVal.charAt(i) == '.');
                        if (hasDec)
                            return false;
                    }
                }
            }
            if (keychar == "#" || keychar == "'" || keychar == "`" || keychar == "!" || keychar == "," || keychar == "~" || keychar == ";" || (keynum >= "40" && keynum <= "44") || (keynum >= "91" && keynum <= "95") || (keynum >= "48" && keynum <= "64") || (keynum >= "34" && keynum <= "38") || (keynum >= "123" && keynum <= "125")) {
                return false;
            }

            else {
                return true;
            }
        }
        function validatespace() {
            var PFirstname = jQuery('#<%=txtGenName.ClientID %>').val();
            if (PFirstname.charAt(0) == ' ' || PFirstname.charAt(0) == '.' || PFirstname.charAt(0) == ',' || PFirstname.charAt(0) == '0' || PFirstname.charAt(0) == '-') {
                jQuery('#<%=txtGenName.ClientID %>').val('');
                jQuery("#spnMsg").text('First Character Cannot Be Space/Dot');
                PFirstname.replace(PFirstname.charAt(0), "");
                return false;
            }
            else {
                jQuery("#spnMsg").text('');
            }
        }
    </script>

    <script type="text/javascript">
        function addCanteenItem(ItemID) {
            if (jQuery.trim(jQuery("#<%=txtTransferQty.ClientID%>").val()) == "" || jQuery.trim(jQuery("#<%=txtTransferQty.ClientID%>").val()) == "0") {
                jQuery("#<%=txtSearch.ClientID%>").focus();
            }
            else {
                // if (jQuery("#lstItems option:selected").text() == "") {
                //     jQuery("#spnMsg").text('Please Select Item');
                //     jQuery("#lstItems").focus();
                //     return false;
                // }
                if (jQuery.trim(jQuery("#<%=txtTransferQty.ClientID%>").val()) < "0") {
                    jQuery("#spnMsg").text('Please Enter Quantity');

                    jQuery("#<%=txtTransferQty.ClientID%>").focus();
                    return false;
                }

                //  if (parseFloat(jQuery.trim(jQuery("#<%=txtTransferQty.ClientID%>").val())) > parseFloat(jQuery("#lstItems option:selected").text().split('#')[2])) {
                //      jQuery("#spnMsg").text('Please Enter Valid Quantity');
                //      jQuery("#<%=txtTransferQty.ClientID%>").focus();
                //      return false;
                //  }
                // var ItemID ="";
                // var ItemID = jQuery("#lstItems").val().split('#')[0];
                jQuery("#spnMsg").text('');
                var AvlQty = 0, countDisc = 0;
                var tranferQty = jQuery.trim(jQuery("#<%=txtTransferQty.ClientID%>").val());
                jQuery.ajax({
                    type: "POST",
                    url: "Services/WebService.asmx/addItem",
                    data: '{ItemID:"' + ItemID.split('#')[0] + '",tranferQty:"' + tranferQty + '",StockID:"' + ItemID.split('#')[1] + '",MedID:"0",DeptLedgerNo:"' + $("#lblDeptLedgerNo").val() + '",AvlQty:"' + AvlQty + '"}',
                    dataType: "json",
                    contentType: "application/json;charset=UTF-8",
                    success: function (response) {
                        Newitem = jQuery.parseJSON(response.d);
                        if (Newitem != null) {
                            var output = jQuery('#tb_Item').parseTemplate(Newitem);
                            jQuery('#ItemOutput').html(output);
                            jQuery('#ItemOutput').show();
                            jQuery('#tb_grdItem tr').each(function () {
                                var id = jQuery(this).attr("id");
                                var $rowid = jQuery(this).closest("tr");
                                if (id != 'Header') {
                                    if (tranferQty > 0) {
                                        if (tranferQty > parseFloat(jQuery.trim($rowid.find("#tdAvlQty").html()))) {
                                            jQuery(this).find("#txtIssueQty").val(parseFloat(jQuery.trim($rowid.find("#tdAvlQty").html())));
                                            jQuery(this).find("#chkItem").prop("checked", true);
                                            tranferQty = tranferQty - parseFloat(jQuery.trim($rowid.find("#tdAvlQty").html()));
                                        }
                                        else {
                                            jQuery(this).find("#txtIssueQty").val(tranferQty);
                                            jQuery(this).find("#chkItem").prop("checked", true);
                                            tranferQty = tranferQty - parseFloat(jQuery.trim(jQuery(this).find("#txtIssueQty").val()));
                                        }
                                    }
                                    if (tranferQty > parseFloat(jQuery.trim($rowid.find("#tdAvlQty").html()))) {
                                        jQuery("#spnMsg").text("Only  '" + parseFloat(jQuery.trim($rowid.find("#tdAvlQty").html())) + " Stock Available");

                                    }
                                }
                            });
                            jQuery("#<%=txtTransferQty.ClientID%>").val('');

                            jQuery('#ItemOutput,#div_Item').hide();
                            addItem();
                            jQuery('#rdoHospitalPatient,#rdoGeneral,#rdoIPD,#btnCanteenSearch,#btnOldPatient').attr('disabled', 'disabled');
                            $('#txtDiscItem').val('0');
                        }
                        else {
                            jQuery("#spnMsg").text('Stock Not Available');
                            return;
                        }
                    },
                    error: function (xhr, status) {

                    }
                });
                jQuery("#<%=txtSearch.ClientID%>").val('');
                $('#canteenItem').combogrid('clear');
                $('#canteenItem').focus();
            }
        }
    </script>

    <script type="text/javascript">
        function check(sender, e) {
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
            formatBox = document.getElementById(sender.id);
            strLen = sender.value.length;
            strVal = sender.value;
            hasDec = false;
            e = (e) ? e : (window.event) ? event : null;
            if (e) {
                var charCode = (e.charCode) ? e.charCode :
                                ((e.keyCode) ? e.keyCode :
                                ((e.which) ? e.which : 0));
                if ((charCode == 45)) {
                    for (var i = 0; i < strLen; i++) {
                        hasDec = (strVal.charAt(i) == '-');
                        if (hasDec)
                            return false;
                    }
                }
                if (charCode == 46) {
                    for (var i = 0; i < strLen; i++) {
                        hasDec = (strVal.charAt(i) == '.');
                        if (hasDec)
                            return false;
                    }
                }
            }

            //List of special characters you want to restrict
            if (keychar == "#" || keychar == "'" || keychar == "`" || keychar == "!" || keychar == "," || keychar == "~" || keychar == ";" || (keynum >= "40" && keynum <= "44") || (keynum >= "91" && keynum <= "95") || (keynum >= "48" && keynum <= "64") || (keynum >= "34" && keynum <= "38") || (keynum >= "123" && keynum <= "125"))
                return false;
            else
                return true;
        }

    </script>
    <script type="text/javascript">
        function clearPaymentControl() {
            $("#canteenItem").combogrid('clear');
            $("#canteenItem").combogrid('reset');
            $("#txtTransferQty").val('');
        }
    </script>
    <script id="tb_OldPatient" type="text/html">
        <table  id="tablePatient" cellspacing="0" rules="all" border="1" style="width:876px;border-collapse:collapse; ">
            <thead>
                <tr id="Tr1">
			        <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Select</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:20px;">Title</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:140px;">First Name</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:140px;">Last Name</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:100px;">MR No.</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Age</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:70px;">Sex</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:116px;">Date</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:200px;">Address</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Contact&nbsp;No.</th>
                    <th class="GridViewHeaderStyle" scope="col" style=" display:none">Email</th>
                    <th class="GridViewHeaderStyle" scope="col" style=" display:none">Country</th>
                    <th class="GridViewHeaderStyle" scope="col" style=" display:none">City</th>
                    <th class="GridViewHeaderStyle" scope="col" style=" display:none">DOB</th>
                    <th class="GridViewHeaderStyle" scope="col" style=" display:none">Relation</th>
                    <th class="GridViewHeaderStyle" scope="col" style=" display:none">RelationName</th>
                    <th class="GridViewHeaderStyle" scope="col" style=" display:none">PanelID</th>
		        </tr>
            </thead>
            <tbody>
            <#            
                var dataLength=OldPatient.length;
                if(_EndIndex>dataLength)
                {           
                _EndIndex=dataLength;
                }
                for(var j=_StartIndex;j<_EndIndex;j++)
                {           
                     var objRow = OldPatient[j];
            #>
                        <tr id="Tr2">                            
                        <td class="GridViewLabItemStyle"  style="width:60px; font:bold; font-size:16px">
                       <a  onclick="bindPatientDetail(this);" style="cursor:pointer; " class="ItDoseButton">
                          Select
                       </a>    </td>                                                    
                        <td  class="GridViewLabItemStyle" id="tdTitle"  style="width:20px;"><#=objRow.Title#></td>
                        <td class="GridViewLabItemStyle" id="tdPFirstName" style="width:140px;"><#=objRow.PFirstName#></td>
                        <td class="GridViewLabItemStyle" id="tdPLastName" style="width:140px;"><#=objRow.PLastName#></td>
                        <td class="GridViewLabItemStyle" id="tdPatientID"  style="width:100px;"><#=objRow.MRNo#></td>
                        <td class="GridViewLabItemStyle" id="tdAge" style="width:70px;"><#=objRow.Age#></td>
                        <td class="GridViewLabItemStyle" id="tdGender" style="width:80px;"><#=objRow.Gender#></td>
                        <td class="GridViewLabItemStyle" id="tdDate" style="width:116px;"><#=objRow.Date#></td>
                        <td class="GridViewLabItemStyle" id="tdHouseNo"  style="width:200px;"><#=objRow.SubHouseNo#></td>
                        <td class="GridViewLabItemStyle" id="tdContactNo" style="width:80px;"><#=objRow.ContactNo#></td>
                        <td class="GridViewLabItemStyle" id="tdEmailID" style="display:none"><#=objRow.Email#></td>
                        <td class="GridViewLabItemStyle" id="tdCountry" style="display:none"><#=objRow.Country#></td>
                        <td class="GridViewLabItemStyle" id="tdCity" style="display:none"><#=objRow.City#></td>
                        <td class="GridViewLabItemStyle" id="tdDOB" style="display:none"><#=objRow.DOB#></td>
                        <td class="GridViewLabItemStyle" id="tdRelation" style="display:none"><#=objRow.Relation#></td>
                        <td class="GridViewLabItemStyle" id="tdRelationName" style="display:none"><#=objRow.RelationName#></td>
                        <td class="GridViewLabItemStyle" id="tdOldPatientPanelID" style="display:none"><#=objRow.panel_ID#></td>
                              </tr>            
            <#}#>
            </tbody>      
        </table>  
        <table id="tablePatientCount" style="border-collapse:collapse;">
            <tr>
                <# if(_PageCount>4) {
                for(var j=0;j<_PageCount;j++){ #>
                    <td class="GridViewLabItemStyle" style="width:8px;"><a href="javascript:void(0);" onclick="showPage('<#=j#>');" ><#=j+1#></a></td>
            <#}         
         }
        #>
     </tr>     
     </table>  
    </script>
    <script type="text/javascript">
        var _PageSize = 4;
        var _PageNo = 0;
        var OldPatient = "";
        function oldPatientSearch() {
            $('#btnView').attr('disabled', 'disabled');
            $('#spnOldPatient').text('');
            $.ajax({
                type: "POST",
                url: "../Common/CommonService.asmx/oldPatientSearch",
                data: '{PatientID:"' + $.trim($("#txtSearchPatientID").val()) + '",PName:"' + $.trim($("#txtPatientFName").val()) + '",LName:"' + $.trim($("#txtPatientLname").val()) + '",ContactNo:"' + $.trim($("#txtPhone").val()) + '",Address:"' + $.trim($("#txtSearchAddress").val()) + '",FromDate:"' + $.trim($("#txtFDSearch").val()) + '",ToDate:"' + $.trim($("#txtTDSearch").val()) + '",PatientRegStatus:"' + 1 + '"}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                success: function (response) {
                    OldPatient = jQuery.parseJSON(response.d);
                    if (OldPatient != null) {
                        _PageCount = OldPatient.length / _PageSize;
                        showPage('0');
                    }
                    else {

                        $("#spnOldPatient").text('Record Not Found');
                        $('#PatientOutput').hide();
                        $('#btnView').removeAttr('disabled');
                    }
                },
                error: function (xhr, status) {
                    $('#btnView').removeAttr('disabled');
                }
            });
        }
        function showPage(_strPage) {
            _StartIndex = (_strPage * _PageSize);
            _EndIndex = eval(eval(_strPage) + 1) * _PageSize;
            var outputPatient = $('#tb_OldPatient').parseTemplate(OldPatient);
            $('#PatientOutput').html(outputPatient);
            $('#PatientOutput').show();
            $('#btnView').attr('disabled', false);
            $('#tablePatient tr').bind('mouseenter mouseleave', function () {
                $(this).toggleClass('hover');

            });
            $('#tablePatientCount td').bind('mouseenter mouseleave', function () {
                $(this).toggleClass('Counthover');
            });
        }
        function pageLoad(sender, args) {
            if (!args.get_isPartialLoad()) {
                $addHandler(document, "keydown", onKeyDown);
            }
        }
        function onKeyDown(e) {
            if (e && e.keyCode == Sys.UI.Key.esc) {
                if ($('#OldPatientSearchPopUp').length > 0) {
                    $('#OldPatientSearchPopUp').animate({ top: -500 }, 500);
                    clearPatientDetail();
                }
            }
        };
        function bindPatientDetail(rowid) {
            var PatientID = $(rowid).closest('tr').find('#tdPatientID').text();
            $('#txtMRNo').val(PatientID);
            $('#OldPatientSearchPopUp').animate({ top: -500 }, 500);
            bindCanteenDetail();
            clearPatientDetail();
        }
        function ChkDate() {
            $.ajax({
                url: "../Common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#txtFDSearch').val() + '",DateTo:"' + $('#txtTDSearch').val() + '"}',
                type: "POST",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#spnOldPatient').text('To date can not be less than from date!');
                        $('#btnView').attr('disabled', 'disabled');
                    }
                    else {
                        $('#spnOldPatient').text('');
                        $('#btnView').removeAttr('disabled');
                    }
                }
            });
        }
        function closePatientDetail() {
            $('#OldPatientSearchPopUp').animate({ top: -500 }, 500);
            clearPatientDetail();
        }
        function clearPatientDetail() {
            $('#txtSearchPatientID,#txtPatientFName,#txtPatientLname,#txtPhone,#txtSearchAddress,#txtIPDNo,#txtActIPDNo').val('');
            $('#PatientOutput').hide();
            $('#tablePatient,#spnOldPatient').html('');
            $("#PatientDetails").css("background-color", "");
        }
        function getDate() {
            $.ajax({
                url: "../Common/CommonService.asmx/getDate",
                data: '{}',
                type: "POST",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    $('#txtTDSearch,#txtFDSearch').val(data);
                }
            });
        }
        $(function () {
            $('#txtTDSearch').change(function () {
                ChkDate();
            });
            $('#txtFDSearch').change(function () {
                ChkDate();
            });
            $('#OldPatientSearchPopUp').animate({ top: -500 }, 500);
            $('#btnOldPatient').click(function (e) {
                $('#OldPatientSearchPopUp').css('left', e.pageX - 830);
                $('#OldPatientSearchPopUp').css('left', e.pageY - 30);
                $('#OldPatientSearchPopUp').animate({ top: 70 }, 1000);
                // $('#PatientDetails').fadeOut("fast");
                $('#PatientDetails').css({ "background-color": "#ccc" });
                $('#txtSearchPatientID').focus();
                getDate();
            });
        });
    </script>
    <div id="OldPatientSearchPopUp" style="position: absolute; top: -500px; border-collapse: collapse; overflow-x: hidden; overflow-y: hidden">
        <div class="Pbody_box_inventory" style="width: 890px; height: 410px">
            <div class="POuter_Box_Inventory" style="width: 886px; text-align: center;">
                <div class="Purchaseheader" style="text-align: right">
                    &nbsp;
                    <em><span style="font-size: 7.5pt">Press esc or click
                            <img src="../../Images/Delete.gif" style="cursor: pointer" onclick="closePatientDetail()" />
                        to close</span></em>
                </div>
                <table style="width: 100%; text-align: center">
                    <tr>
                        <td style="text-align: center">
                            <b>Search Old Patient Details</b>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: center">
                            <span id="spnOldPatient" class="ItDoseLblError"></span>
                        </td>
                    </tr>
                </table>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center; width: 886px;">
                <table style="width: 100%; border-collapse: collapse">
                    <tr style="font-size: 10pt">
                        <td style="width: 20%; text-align: right">MR No. :&nbsp;
                        
                        </td>
                        <td style="width: 30%; text-align: left;">
                            <input type="text" id="txtSearchPatientID" title="Enter MR No." maxlength="20" style="width: 150px" />

                        </td>
                        <td style="width: 20%; text-align: right; display: none;">&nbsp;
                        </td>
                        <td style="width: 30%; text-align: left; display: none;"></td>
                    </tr>
                    <tr style="font-size: 10pt">
                        <td style="width: 20%; text-align: right">First Name :&nbsp;
                        </td>
                        <td style="width: 30%; text-align: left;">
                            <input type="text" id="txtPatientFName" title="Enter First Name" maxlength="20" style="width: 150px" />

                        </td>
                        <td style="width: 20%; text-align: right">Last Name :&nbsp;
                        </td>
                        <td style="width: 30%; text-align: left;">
                            <input type="text" id="txtPatientLname" title="Enter Last Name" maxlength="20" style="width: 150px" />

                        </td>
                    </tr>
                    <tr style="font-size: 10pt;">
                        <td style="width: 20%; text-align: right">Contact No. :&nbsp;
                        </td>
                        <td style="width: 30%; text-align: left; margin-left: 40px;">

                            <input type="text" id="txtPhone" title="Enter Contact No." maxlength="15" style="width: 150px" />

                        </td>
                        <td style="width: 20%; text-align: right">Address :&nbsp;
                        </td>
                        <td style="width: 30%; text-align: left;">
                            <input type="text" id="txtSearchAddress" title="Enter Address" maxlength="50" style="width: 150px" />
                        </td>
                    </tr>
                    <tr style="font-size: 10pt">
                        <td style="width: 20%; text-align: right">From Date :&nbsp;
                        </td>
                        <td style="width: 30%; text-align: left;">
                            <asp:TextBox ID="txtFDSearch" runat="server" ToolTip="Click To Select From Date"
                                Width="150px" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="fc1" runat="server" TargetControlID="txtFDSearch" Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                        </td>
                        <td style="width: 20%; text-align: right">To Date :&nbsp;
                        </td>
                        <td style="width: 30%; text-align: left;">
                            <asp:TextBox ID="txtTDSearch" runat="server" ClientIDMode="Static"
                                ToolTip="Click To Select To Date " Width="150px"></asp:TextBox>
                            <cc1:CalendarExtender ID="fc2" runat="server" TargetControlID="txtTDSearch" Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                            &nbsp;&nbsp;
                        </td>
                    </tr>
                    <tr style="font-size: 10pt; display: none" id="IPDNo">
                        <td style="width: 20%; text-align: right">IPD No. :&nbsp;
                        </td>
                        <td style="width: 30%; text-align: left;">
                            <asp:TextBox ID="TextBox1" runat="server" ToolTip="Enter IPD No."
                                Width="150px" ClientIDMode="Static"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="ftbIPD" runat="server" TargetControlID="txtIPDNo" FilterType="Numbers"></cc1:FilteredTextBoxExtender>

                        </td>
                        <td style="width: 20%; text-align: right">&nbsp;
                        </td>
                        <td style="width: 30%; text-align: left;">
                            <input type="text" id="txtActIPDNo" maxlength="50" style="width: 150px; display: none" />

                        </td>
                    </tr>
                </table>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center; width: 886px;">
                <input type="button" id="btnView" value="View" class="ItDoseButton" title="Click to View" onclick="oldPatientSearch()" />
            </div>
            <div class="POuter_Box_Inventory" style="width: 886px;">
                <div class="Purchaseheader">
                    Patient Detail
                </div>
                <div id="PatientOutput" style="max-height: 236px; overflow-x: auto;">
                </div>
            </div>
        </div>

    </div>    
    <script type="text/javascript">
        function hideCanteenDetail(rowID) {
            $(rowID).closest('tr').find('#imgMinus').hide();
            $(rowID).closest('tr').find('#imgPlus').show();
            var medID = $(rowID).closest('tr').find('#tdMedicine_ID').text();

            $('#tr_Detail_' + medID).hide();
            $("#spnMsg").text('');
        }
        function bindCanteenMed(rowID) {
            $("#spnMsg").text('');
            var itemID = $(rowID).closest('tr').find('#tdMedicine_ID').text();


            var MedID = $(rowID).closest('tr').find('#tdPatientMedicineID').text();
            var AvlQty = 0;
            if ($('input[name=group1]:checked').val() == "3")
                AvlQty = $(rowID).closest('tr').find('#tdMedAvlQty').text();

            jQuery.ajax({
                type: "POST",
                url: "CanteenIssue.aspx/addItem",
                data: '{ItemID:"' + itemID + '", MedID:"' + MedID + '",DeptLedgerNo:"' + $("#lblDeptLedgerNo").val() + '",AvlQty:"' + AvlQty + '"}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                success: function (response) {
                    phitem = jQuery.parseJSON(response.d);
                    if (phitem != null) {

                        var output = $('#tb_CanteenData').parseTemplate(phitem);
                        $('#td_Detail_' + itemID).html(output);
                        $('#td_Detail_' + itemID).show();
                        $('#tr_Detail_' + itemID).show();
                        $(rowID).closest('tr').find('#imgMinus').show();
                        $(rowID).closest('tr').find('#imgPlus').hide();
                    }
                    else {
                        $("#spnCanteenMsg").text('Stock Not Available');
                    }
                },
                error: function (xhr, status) {

                    $("#spnCanteenMsg").text('Error occurred, Please contact administrator');
                }

            });
        }
        function hideMedicine(rowID) {
            $("#canteenDetail").hide();
        }
        function chkSelect(rowID) {

        }
    </script>
    <script id="tb_CanteenData" type="text/html">   
        <table class="GridViewStyle" cellspacing="0" rules="all" border="1"   id="canteenDetail" style="width:780px;border-collapse:collapse;">                                  
		    <tr id="MedHeader">
                <th style="width:4%;"></th>
			    <th class="GridViewHeaderStyle" scope="col" style="width:4%;"></th>
                <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Batch&nbsp;No.</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Expirable</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Expiry</th>
			    <th class="GridViewHeaderStyle" scope="col" style="width:70px;">Buy Price</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Selling Price</th>
			    <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Available&nbsp;Qty.</th>
			    <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Unit</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Issue Qty.</th>
			    <th class="GridViewHeaderStyle" scope="col" style="width:90px;display:none">stockID</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:90px;display:none">ItemID</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:90px;display:none">ItemName</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:90px;display:none">SubCategoryID</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:90px;display:none">ToBeBilled</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:90px;display:none">Type_ID</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:90px;display:none">IsUsable</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:90px;display:none">ServiceItemID</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:90px;display:none">PatientMedicine_ID</th>            
                <th  style="width:30px;"></th>
		    </tr>
       <#       
              var dataLength=phitem.length;
              window.status="Total Records Found :"+ dataLength;
              var objRow;   
        for(var k=0;k<dataLength;k++)
        {
        objRow = phitem[k];      
            #>        
                  <tr >
                      <td style="width:4%;">                      
                      </td>
                    <td class="GridViewLabItemStyle" style="width:4%;"><input  onclick="chkSelect(this)"  class="medCheck"
                         <#  if(objRow.MRP =="0"){#>  disabled="disabled"    <#}#>                                                                                                              
                         name="chk_<#=objRow.stockid#>" type="checkbox" id="chkSelectMed" />  </td>
                    <td class="GridViewLabItemStyle" id="tdPhBatchNumber" style="width:60px;"><#=objRow.BatchNumber#></td>
                    <td class="GridViewLabItemStyle" id="tdPhIsExpirable" style="width:60px;text-align:center"><#=objRow.isexpirable#></td>
                    <td class="GridViewLabItemStyle" id="tdPhMedExpiryDate" style="width:90px;text-align:center"><#=objRow.MedExpiryDate#></td>                 
                    <td class="GridViewLabItemStyle" id="tdPhUnitPrice" style="width:90px;text-align:right"><#=objRow.UnitPrice#></td>
                    <td class="GridViewLabItemStyle" id="tdPhMRP" style="width:90px;text-align:right"><#=objRow.MRP#></td>
                    <td class="GridViewLabItemStyle" id="tdMedAvlQty" style="width:90px;text-align:right"><#=objRow.AvlQty#></td>
                    <td class="GridViewLabItemStyle" id="tdPhUnitType" style="width:90px; text-align:center"><#=objRow.UnitType#></td>
                    <td class="GridViewLabItemStyle" style="width:30px;text-align:right"><input type="text" id="txtMedIssueQty" autocomplete="off"  style="width:60px"
                      <#  if(objRow.MRP =="0"){#> disabled="disabled" <#}#>                                                                                                                 
                         onkeypress="return checkForSecondDecimal(this,event)" class="ItDoseTextinputNum"  onkeyup="CheckQty(this);"/></td>
                    <td class="GridViewLabItemStyle" id="tdPhStockID" style="width:90px;display:none"><#=objRow.stockid#></td>
                    <td class="GridViewLabItemStyle" id="tdPhItemID" style="width:90px;display:none"><#=objRow.ItemID#></td>  
                      <td class="GridViewLabItemStyle" id="tdPhItemName" style="width:90px;display:none"><#=objRow.ItemName#></td>                       
                      <td class="GridViewLabItemStyle" id="tdPhSubCategoryID" style="width:90px;display:none"><#=objRow.SubCategoryID#></td>                       
                      <td class="GridViewLabItemStyle" id="tdPhToBeBilled" style="width:90px;display:none"><#=objRow.ToBeBilled#></td>                       
                      <td class="GridViewLabItemStyle" id="tdPhType_ID" style="width:90px;display:none"><#=objRow.Type_ID#></td>                       
                      <td class="GridViewLabItemStyle" id="tdPhIsUsable" style="width:90px;display:none"><#=objRow.IsUsable#></td>                       
                      <td class="GridViewLabItemStyle" id="tdPhServiceItemID" style="width:90px;display:none"><#=objRow.ServiceItemID#></td> 
                      <td class="GridViewLabItemStyle" id="tdPhPatientMedicine_ID" style="width:90px;display:none"><#=objRow.MedID#></td>                       
                     <td class="GridViewLabItemStyle" id="tdNewAvlQty" style="width:90px;display:none"><#=objRow.NewAvlQty#></td>                       

                                                        
                 </tr>
            <#}#>                      
     </table>     
    </script>
    <script type="text/javascript">
        function addCanteen() {
            var con = 0; var chk = 1, chkIssueQty = 0, NewAvlQty = 0;
            jQuery("#spnCanteenMsg").text('');
            if ($('input[name=group1]:checked').val() == "3") {

                //$("#CanteenIPD tr").each(function () {
                //    var id = jQuery(this).closest("tr").attr("id");
                //    var $rowid = jQuery(this).closest("tr");
                var issueQty = 0;
                //    if (id != "headerCanteenIPD") {
                $("#canteenDetail tr").each(function () {
                    var id1 = jQuery(this).closest("tr").attr("id");
                    var $rowid1 = jQuery(this).closest("tr");

                    if (id1 != "MedHeader") {
                        NewAvlQty += parseFloat(jQuery($rowid1).find("#tdNewAvlQty").text());
                        if (jQuery(this).find("#chkSelectMed").is(":checked")) {
                            issueQty += parseFloat(jQuery.trim(jQuery($rowid1).find("#txtMedIssueQty").val()));

                            if (parseFloat(jQuery($rowid1).find("#tdNewAvlQty").text()) < parseFloat(jQuery.trim(jQuery($rowid1).find("#txtMedIssueQty").val()))) {
                                jQuery("#spnCanteenMsg").text('Issue Qty. Cannot Greater Then Indent Qty.');
                                modelAlert('Issue Qty. Cannot Greater Then Indent Qty.');
                                chkIssueQty = 1;
                                return;
                            }
                        }

                    }
                });
                if (chkIssueQty != "0")
                    return;

                if (parseFloat(issueQty) > parseFloat(NewAvlQty)) {
                    jQuery("#spnCanteenMsg").text('Issue Qty. Cannot Greater Then Indent Qty.');
                    modelAlert('Issue Qty. Cannot Greater Then Indent Qty.');
                    chkIssueQty = 1;
                    return;
                }
            }

            if (chkIssueQty != "0")
                return;

            $("#canteenDetail tr").each(function () {
                var id = jQuery(this).closest("tr").attr("id");
                var $rowid = jQuery(this).closest("tr");
                if ((id != "MedHeader") && (jQuery(this).find("#chkSelectMed").is(":checked"))) {
                    var issueQty = jQuery.trim(jQuery(this).find("#txtMedIssueQty").val());

                    if ((jQuery.trim(jQuery(this).find("#txtMedIssueQty").val()) <= "0") || (jQuery.trim(jQuery(this).find("#txtMedIssueQty").val()) == "")) {
                        jQuery("#spnCanteenMsg").text('Please Enter Issue Qty.');
                        jQuery(this).find("#txtMedIssueQty").focus();
                        con = 1;
                        return false;
                    }
                    chk += chk;
                    if (parseFloat(jQuery.trim(jQuery(this).find("#txtMedIssueQty").val())) > parseFloat((jQuery.trim($rowid.find("#tdMedAvlQty").html())))) {
                        jQuery("#spnCanteenMsg").text('Issue Qty. Can Not Greater Then Available Qty.');
                        con = 1;
                        return false;
                    }
                    var stockID = $rowid.find("#tdPhStockID").html();
                    var itemName = $rowid.find("#tdPhItemName").html();
                    var medID = $rowid.find("#tdPhItemName").html();
                    jQuery("#tb_grdIssueItem tr").each(function () {
                        var IssueItemid = jQuery(this).closest("tr").attr("id");
                        var $IssueItemrowid = jQuery(this).closest("tr");
                        if (IssueItemid != "IssueItemHeader") {
                            var IssuestockID = $IssueItemrowid.find("#tdStockID").html();
                            if (stockID == IssuestockID) {
                                jQuery("#spnCanteenMsg").text(itemName + ' Already Selected');
                                con = 1;
                                return false;
                            }
                        }

                    });
                }

            });
            if (con == "1") {

                return false;
            }
            if (chk == "1") {
                jQuery("#spnCanteenMsg").text('Please Check Atleast One Item');
                return false;
            }
            var amt = 0; var totalGST = 0, disc = 0, isItemWiseDisc = 0;
            var totalAmt = 0, totalDisc = 0, totalGrossAmt = 0, isItemWiseDisc = 0;
            if ((con == "0") && (chk > 1)) {
                jQuery("#spnMsg,#spnCanteenMsg").text('');
                jQuery("#canteenDetail tr").each(function () {
                    var id = jQuery(this).attr("id");
                    var $rowid = jQuery(this).closest("tr");
                    if ((id != "MedHeader") && ($rowid.find("#chkSelectMed").is(':checked'))) {
                        RowCount = jQuery("#tb_grdIssueItem tr").length;

                        RowCount = RowCount + 1;
                        var newRow = jQuery('<tr />').attr('id', 'tr_' + RowCount);
                        newRow.html(
                            '</td><td class="GridViewLabItemStyle" id="tdItemName">' + $rowid.find("#tdPhItemName").html() +
                              '</td><td class="GridViewLabItemStyle" id="tdBatchNumber">' + $rowid.find('#tdPhBatchNumber').html() +
                              '</td><td class="GridViewLabItemStyle" id="tdisExpirable">' + $rowid.find('#tdPhIsExpirable ').html() +
                              '</td><td class="GridViewLabItemStyle" id="tdMedExpiryDate">' + $rowid.find('#tdPhMedExpiryDate').html() +
                              '</td><td class="GridViewLabItemStyle" style="text-align:centre;" id="tdUnitType">' + $rowid.find('#tdPhUnitType').html() +
                              '</td><td class="GridViewLabItemStyle" style="text-align:right;display:none" id="tdActualIssueQty">' + jQuery(this).find('#txtMedIssueQty').val() +
                              '</td><td class="GridViewLabItemStyle" style="text-align:centre;" id="tdTotalAvlQty">' + $rowid.find("#tdMedAvlQty").html() +
                              '</td><td class="GridViewLabItemStyle" style="text-align:right" id="tdIssueQty"><input type="text" autocomplete="off" id="txtIssueQty" maxlength="4"  onkeyup="calAmount(this);"  onkeypress="return checkNumeric(event,this);" style="width:54px;text-align:right" value=' + jQuery(this).find('#txtMedIssueQty').val() + ' />' +
                              '</td><td class="GridViewLabItemStyle" style="text-align:right" id="tdMRP">' + $rowid.find('#tdPhMRP').html() +
                              '</td><td class="GridViewLabItemStyle" style="text-align:right" id="tdDiscountAmt">' + disc +
                              '</td><td class="GridViewLabItemStyle" style="text-align:right;" id="tdAmount">' + precise_round(parseFloat((parseFloat(jQuery(this).find('#txtMedIssueQty').val()) * parseFloat(($rowid.find('#tdPhMRP').html())))), 2) +
                              '</td><td class="GridViewLabItemStyle" style="text-align:right;display:none" id="tdGrossAmount">' + precise_round(parseFloat((parseFloat(jQuery(this).find('#txtMedIssueQty').val()) * parseFloat(($rowid.find('#tdPhMRP').html())))), 2) +
                              '</td><td class="GridViewLabItemStyle" style="text-align:right;display:none" id="tdisItemWiseDisc">' + isItemWiseDisc +
                              '</td><td class="GridViewLabItemStyle" style="text-align:centre;display:none" id="tdDiscountPer">' + $.trim($("#txtDiscItem").val()) +
                              '</td><td class="GridViewLabItemStyle" style="text-align:centre;display:none" id="tdStockID">' + $rowid.find('#tdPhStockID').html() +
                              '</td><td class="GridViewLabItemStyle" style="text-align:centre;display:none" id="tdItemID">' + $rowid.find('#tdPhItemID').html() +
                              '</td><td class="GridViewLabItemStyle" style="text-align:centre;display:none" id="tdSubCategoryID">' + $rowid.find('#tdPhSubCategoryID').html() +
                              '</td><td class="GridViewLabItemStyle" style="text-align:centre;display:none" id="tdUnitPrice">' + $rowid.find('#tdPhUnitPrice').html() +
                              '</td><td class="GridViewLabItemStyle" style="text-align:centre;display:none" id="tdToBeBilled">' + $rowid.find('#tdPhToBeBilled').html() +
                              '</td><td class="GridViewLabItemStyle" style="text-align:centre;display:none" id="tdIsUsable">' + $rowid.find('#tdPhIsUsable').html() +
                              '</td><td class="GridViewLabItemStyle" style="text-align:centre;display:none" id="tdType_ID">' + $rowid.find('#tdPhType_ID').html() +
                              '</td><td class="GridViewLabItemStyle" style="text-align:centre;display:none" id="tdPatientMedicine">' + $rowid.find("#tdPhPatientMedicine_ID").html() +
                              '</td><td class="GridViewLabItemStyle" style="text-align:center;" id="imgPhRemove"><img id="imgRmv" src="../../Images/Delete.gif" onclick="DeleteRowPh(this);" onmouseover="chngcur()" class="canteenRemove"  style="cursor:pointer;" title="Click To Remove"/></td>'

                            );
                        jQuery("#tb_grdIssueItem").append(newRow);
                        jQuery("#tb_grdIssueItem").show();
                        $find('mpCanteen').hide();

                    }

                });

                var count = 0;
                jQuery("#tb_grdIssueItem tr").each(function () {
                    var id = jQuery(this).closest("tr").attr("id");
                    if (id != "IssueItemHeader") {
                        totalAmt += parseFloat(jQuery(this).closest("tr").find("#tdAmount").html());
                        totalDisc += parseFloat(jQuery(this).closest("tr").find("#tdDiscountAmt").html());
                        totalGrossAmt += parseFloat(jQuery(this).closest("tr").find("#tdGrossAmount").html());
                        count += parseFloat(jQuery(this).closest("tr").find("#tdisItemWiseDisc").html());
                    }
                });



                jQuery('#ItemOutput').html('');
                jQuery('#ItemOutput,#btnAddItem,#div_Item').hide();
                jQuery("#lblBillAmount").text(totalAmt);
                jQuery("#lblDiscAmount").text(totalDisc);
                jQuery("#lblGrossAmt").text(totalGrossAmt);



                jQuery('#lblBill,#btnSave,#lblBillAmount,#div_Issue').show();
                //   updateTotalAmount(jQuery('#lblGrossAmt').text(), jQuery('#lblBillAmount').text(), jQuery("#lblDiscAmount").text(), "0");
                $("#ddlPanelCompany").attr('disabled', 'disabled');
                //AddAmount();
                // jQuery("#<%=txtSearch.ClientID%>").focus();
                $("#spnTotalMedicine").text(jQuery("#tb_grdIssueItem tr").length - 1);
                $('#canteenItem').focus();
                jQuery('#rdoHospitalPatient,#rdoGeneral,#rdoIPD,#btnCanteenSearch,#btnOldPatient').attr('disabled', 'disabled');

                showChkDisc(count);


            }


        }

    </script>    
    <script type="text/javascript">
        function removeItemWiseDisc() {
            var msg = "Are you sure to Remove Item Wise Disc.";
            var Ok = confirm(msg);
            if (Ok) {
                jQuery("#tb_grdIssueItem tr").each(function () {
                    var id = jQuery(this).closest("tr").attr("id");
                    if (id != "IssueItemHeader") {

                        parseFloat(jQuery(this).closest("tr").find("#tdDiscountAmt").html(0));
                        parseFloat(jQuery(this).closest("tr").find("#tdGrossAmount").html());
                        parseFloat(jQuery(this).closest("tr").find("#tdisItemWiseDisc").html(0));
                        parseFloat(jQuery(this).closest("tr").find("#tdAmount").html(parseFloat(parseFloat(jQuery(this).closest("tr").find("#tdMRP").html()) * (parseFloat(jQuery(this).closest("tr").find("#txtIssueQty").val())))));
                    }

                });
                var count = 0, totalAmt = 0, totalDisc = 0, totalGrossAmt = 0;
                jQuery("#tb_grdIssueItem tr").each(function () {
                    var id = jQuery(this).closest("tr").attr("id");
                    if (id != "IssueItemHeader") {
                        totalAmt += parseFloat(jQuery(this).closest("tr").find("#tdAmount").html());
                        totalDisc += parseFloat(jQuery(this).closest("tr").find("#tdDiscountAmt").html());
                        totalGrossAmt += parseFloat(jQuery(this).closest("tr").find("#tdGrossAmount").html());
                        count += parseFloat(jQuery(this).closest("tr").find("#tdisItemWiseDisc").html());
                    }
                });


                jQuery("#lblBillAmount").text(totalAmt);
                jQuery("#lblDiscAmount").text(totalDisc);
                jQuery("#lblGrossAmt").text(totalGrossAmt);
                jQuery('#lblBill,#btnSave,#lblBillAmount,#div_Issue').show();
                //   updateTotalAmount(jQuery('#lblGrossAmt').text(), jQuery('#lblBillAmount').text(), jQuery("#lblDiscAmount").text(), "0");
                $("#ddlPanelCompany").attr('disabled', 'disabled');
                //AddAmount();
                //jQuery("#<%=txtSearch.ClientID%>").focus();
                $("#spnTotalMedicine").text(jQuery("#tb_grdIssueItem tr").length - 1);
                $('#canteenItem').focus();
                jQuery('#rdoHospitalPatient,#rdoGeneral,#rdoIPD,#btnCanteenSearch,#btnOldPatient').attr('disabled', 'disabled');

                showChkDisc(count);
            }
            else {

            }
        }
    </script>
    <script type="text/javascript">
        function checkNumeric(e, sender) {
            var charCode = (e.which) ? e.which : e.keyCode;

            if (charCode == "9")
                return true;
            if (charCode != 8 && charCode != 0 && charCode != 37 && charCode != 39 && charCode != 46 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            return true;
        }
        function calAmount(rowID) {
            var issueQty = jQuery(rowID).closest("tr").find("#txtIssueQty").val();
            if (isNaN(issueQty) || issueQty == "")
                issueQty = 0;
            if (parseFloat($(rowID).closest("tr").find("#tdTotalAvlQty").html()) < parseFloat(issueQty)) {
                jQuery("#spnMsg").text('Please Enter Valid Quantity');
                jQuery(rowID).closest("tr").find("#txtIssueQty").val(jQuery(rowID).closest("tr").find("#tdActualIssueQty").html());

            }
            else {
                jQuery("#spnMsg").text('');
            }
            issueQty = parseFloat(jQuery(rowID).closest("tr").find("#txtIssueQty").val());
            if (isNaN(issueQty) || issueQty == "")
                issueQty = 0;

            if (parseFloat(issueQty) != parseFloat(jQuery(rowID).closest("tr").find("#tdActualIssueQty").html())) {
                jQuery(rowID).closest('tr').css("background-color", "#FDE76D");
            }
            else {
                jQuery(rowID).closest('tr').css("background-color", "transparent");
            }
            jQuery(rowID).closest("tr").find("#txtIssueQty").val(Number(issueQty));
            if (parseFloat(jQuery(rowID).closest("tr").find("#tdDiscountAmt").html()) > 0) {
                disc = precise_round(parseFloat((parseFloat(issueQty) * parseFloat((jQuery(rowID).closest("tr").find('#tdMRP').html())) * parseFloat(jQuery.trim(jQuery(rowID).closest("tr").find('#tdDiscountPer').html()))) / 100), 2);
                amt = precise_round(parseFloat((parseFloat(issueQty) * parseFloat((jQuery(rowID).closest("tr").find('#tdMRP').html()))) - disc), 2);
                isItemWiseDisc = 1;
            }
            else {
                amt = precise_round(parseFloat((parseFloat(issueQty) * parseFloat((jQuery(rowID).closest("tr").find('#tdMRP').html())))), 2);
                disc = 0;
                isItemWiseDisc = 0;
            }
            var totalGrossAmt = precise_round(parseFloat(issueQty) * parseFloat(jQuery(rowID).closest("tr").find('#tdMRP').html()), 2);
            jQuery(rowID).closest("tr").find('#tdAmount').html(amt);
            jQuery(rowID).closest("tr").find('#tdGrossAmount').html(totalGrossAmt);

            var totalAmt = 0, totalDisc = 0, totalGrossAmt = 0;
            jQuery("#tb_grdIssueItem tr").each(function () {
                var id = jQuery(this).closest("tr").attr("id");
                if (id != "IssueItemHeader") {
                    totalAmt += parseFloat(jQuery(this).closest("tr").find("#tdAmount").html());
                    totalDisc += parseFloat(jQuery(this).closest("tr").find("#tdDiscountAmt").html());
                    totalGrossAmt += parseFloat(jQuery(this).closest("tr").find("#tdGrossAmount").html());
                }
            });
            jQuery("#lblBillAmount").text(totalAmt);
            jQuery("#lblDiscAmount").text(totalDisc);
            jQuery("#lblGrossAmt").text(totalGrossAmt);
            // updateTotalAmount(jQuery('#lblGrossAmt').text(), jQuery('#lblBillAmount').text(), jQuery("#lblDiscAmount").text(), "0");
        }
    </script>
</asp:Content>




