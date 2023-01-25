<%@ Page Language="C#" AutoEventWireup="true" CodeFile="StockAdjustment.aspx.cs"
    Inherits="Design_Store_StockAdjustment" MasterPageFile="~/DefaultHome.master" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="asp" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <script type="text/javascript" src="../../Scripts/Search.js"></script>
    <script type="text/javascript">
        var keys = [];
        var values = [];
        $(document).ready(function () {
            var options = $('#<% = lstItem.ClientID %> option');
            $.each(options, function (index, item) {
                keys.push(item.value);
                values.push(item.innerHTML);
            });
            $('#<% = txtFirstNameSearch.ClientID %>').keyup(function (e) {
                searchByFirstChar(document.getElementById('<%=txtFirstNameSearch.ClientID%>'), document.getElementById('<%=txtCPTCodeSearch.ClientID%>'), document.getElementById('<%=txtInBetweenSearch.ClientID%>'), document.getElementById('<%=lstItem.ClientID%>'), "", values, keys, e)
            });
            $('#<%=txtCPTCodeSearch.ClientID %>').keyup(function (e) {
                searchByCPTCode(document.getElementById('<%=txtFirstNameSearch.ClientID%>'), document.getElementById('<%=txtCPTCodeSearch.ClientID%>'), document.getElementById('<%=txtInBetweenSearch.ClientID%>'), document.getElementById('<%=lstItem.ClientID%>'), "", values, keys, e)
            });
            $('#<%=txtInBetweenSearch.ClientID %>').keyup(function (e) {
                searchByInBetween(document.getElementById('<%=txtFirstNameSearch.ClientID%>'), document.getElementById('<%=txtCPTCodeSearch.ClientID%>'), document.getElementById('<%=txtInBetweenSearch.ClientID%>'), document.getElementById('<%=lstItem.ClientID%>'), "", values, keys, e)

            });
        });
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
        function ClickSelectbtn(e, btnName) {
            //the purpose of this function is to allow the enter key to 
            //point to the correct button to click.
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

        function validatedot() {
            if (($("#<%=txtQty.ClientID%>").val().charAt(0) == ".")) {
                $("#<%=txtQty.ClientID%>").val('');
                return false;
            }
        }

    </script>
    <script type="text/javascript">
        function AdjustmentStock(txNarration, cmdApproved) {
            var Narration = document.getElementById(txNarration).value;
            var Approved = document.getElementById(cmdApproved).value;
            if (Narration.length == 0) {
                alert("Please Enter Narration");
                document.getElementById(txNarration).focus();
                return false;
            }
            if (Approved.length == 0) {
                alert("Please Select Approved by");
                document.getElementById(cmdApproved).focus();
                return false;
            }
            document.Form1.Submit();
            return true;
        }

        function clicked() {

            if ($("#<%=ChkIsExpirable.ClientID %>").attr('checked')) {


                $("#<%=ucFromDate.ClientID %>").attr('disabled', false);
                if ((!($("#<%=ucFromDate.ClientID %>").val().length) > 0)) {

                    $("#<%=ucToDate.ClientID %>").attr('disabled', true);
                }
                else {
                    $("#<%=ucToDate.ClientID %>").attr('disabled', false);
                }
            }
            else {

                $("#<%=ucFromDate.ClientID %>").attr('disabled', true);
                $("#<%=ucToDate.ClientID %>").attr('disabled', true);
                $("#<%=ucFromDate.ClientID %>").val('');
                $("#<%=ucToDate.ClientID %>").val('');
            }
        }
        function listboxupdate() {
            var dept = '<%= Session["DeptLedgerNo"].ToString() %>';
            var lstInvestigation = $("#<%=lstItem.ClientID %>");
            $.ajax({
                url: "../Common/CommonService.asmx/listbox",
                data: '{ FromDate: "' + $("#<%=ucFromDate.ClientID %>").val() + '",ToDate:"' + $("#<%=ucToDate.ClientID %>").val() + '",Dept:"' + dept + '"}', // parameter map
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    InvData = jQuery.parseJSON(result.d);
                    $("#<%=lstItem.ClientID %>").empty();

                    if (InvData.length == 0) {
                        lstInvestigation.append($("<option></option>").val("0").html("---No Data Found---"));
                    }
                    else {

                        for (i = 0; i < InvData.length; i++) {
                            lstInvestigation.append($("<option></option>").val(InvData[i].ItemId).html(InvData[i].itemname));
                        }
                    }
                },
                error: function (xhr, status) {
                    alert("Error ");
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }
        $(document).ready(function () {

            $('#ucToDate').change(function () {

                listboxupdate();
            });
            if ($("#<%=ChkIsExpirable.ClientID %>").attr('checked')) {
                if ((($("#<%=ucFromDate.ClientID %>").val().length) > 0) && (($("#<%=ucToDate.ClientID %>").val().length) > 0)) {
                    listboxupdate();
                }

            }


            if (!($("#<%=ucFromDate.ClientID %>").val().length) > 0) {
                $("#<%=ucToDate.ClientID %>").attr("disabled", "disabled");
            }

            $("#<%=ucFromDate.ClientID %>").change(function () {
                if ($("#<%=ucFromDate.ClientID %>").val().length > 0) {
                    $("#<%=ucToDate.ClientID %>").removeAttr("disabled");
                }
                else {
                    $("#<%=ucToDate.ClientID %>").attr("disabled", "disabled");
                }
            });


            $("#<%=ucFromDate.ClientID %>").bind('keypress keydown', function (e) {
                var keycode = e.keyCode ? e.keyCode : e.which;
                if ((keycode != 8) && (keycode != 46)) {
                    $("#<%=ucFromDate.ClientID %>").attr("disabled", true);
                }
                else {
                    $("#<%=ucFromDate.ClientID %>").val('');
                    $("#<%=ucToDate.ClientID %>").val('');
                    $("#<%=ucToDate.ClientID %>").attr("disabled", "disabled");

                }
            });
            $('#ucFromDate').change(function () {
                if (($("#<%=ucToDate.ClientID %>").val().length) > 0) {
                    listboxupdate();

                }
            });

            if (!($("#<%=ChkIsExpirable.ClientID %>").attr('checked'))) {
                $("#<%=ucToDate.ClientID %>").attr("disabled", "disabled");
                $("#<%=ucFromDate.ClientID %>").attr("disabled", "disabled");
                //     
                //                $('#<%=pnlInfo.ClientID %>').hide();
                //                $('#<%=grdReturnItems.ClientID %>').hide();
                //                $("#<%=btnAdjustment.ClientID %>").attr("disabled", "disabled");

            }
            //            else if (!($("#<%=ucFromDate.ClientID %>").val().length) > 0) {
            //              
            //                $('#<%=pnlInfo.ClientID %>').hide();
            //                $('#<%=grdReturnItems.ClientID %>').hide();
            //                $("#<%=btnAdjustment.ClientID %>").attr("disabled", "disabled");
            //            }
        });
        function ValidateDate() {
            var start1 = $("#<%=ucFromDate.ClientID %>").val();
            var end1 = $("#<%=ucToDate.ClientID %>").val();
            if (start1 != '' && end1 == '') {
                $("#<%=lblMsg.ClientID %>").text('Select From Date');

                return false;
            }
            if (end1 != '' && start1 == '') {
                $("#<%=lblMsg.ClientID %>").text('Select To  Date ');
                return false;
            }

            var splitdate1 = start1.split("-");
            var dt11 = splitdate1[1] + " " + splitdate1[0] + ", " + splitdate1[2];
            var splitdate11 = end1.split("-");
            var dt21 = splitdate11[1] + " " + splitdate11[0] + ", " + splitdate11[2];

            var newStartDate1 = Date.parse(dt11);
            var newEndDate1 = Date.parse(dt21);

            if (newStartDate1 > newEndDate1) {
                alert("To date can not be less than from date!");
                $("#<%=ucToDate.ClientID %>").val('');
                return false;
            }
        }
        function ButtonDisable(btn) {
            if ($("#<%=cmbAprroved.ClientID%>").val() == "0") {
                $("#<%=lblMsg.ClientID%>").text('Please Select Approved By');
                $("#<%=cmbAprroved.ClientID%>").focus();
                return false;
            }
            if (Page_IsValid) {
                document.getElementById('<%=btnAdjustment.ClientID%>').disabled = true;
                document.getElementById('<%=btnAdjustment.ClientID%>').value = 'Submitting...';
                __doPostBack('ctl00$ContentPlaceHolder1$btnAdjustment');
            }
            else {
                document.getElementById('<%=btnAdjustment.ClientID%>').disabled = false;
                document.getElementById('<%=btnAdjustment.ClientID%>').value = 'Save';
            }
        }

        function changeqty() {
            if ($('#txtactualqty').val() != "") {
                var actualqty = $("#txtactualqty").val();
                var Qtyinhand = $('#<%=lblQOH.ClientID%>').text();
                var qty = parseFloat(Qtyinhand) - parseFloat(actualqty);
                $('#txtQty').val(qty);
            }

        }
    </script>

    <asp:ScriptManager ID="ScriptManager1" runat="server">
    </asp:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>Stock Process Medical (-)</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />

        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Store Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList runat="server" ID="rblStoreType" RepeatDirection="Horizontal" OnSelectedIndexChanged="rblStoreType_SelectedIndexChanged" AutoPostBack="True">
                                <asp:ListItem Value="STO00001">Med. Store</asp:ListItem>
                                <asp:ListItem Value="STO00002">Gen. Store</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Approved By
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList CssClass="requiredField" ID="cmbAprroved" runat="server" TabIndex="1"
                                Width="">
                            </asp:DropDownList>
                            <asp:Label ID="Label1" runat="server" Style="color: Red; font-size: 10px;"></asp:Label>
                            <asp:RequiredFieldValidator ID="rqApproved" runat="server" ErrorMessage="Select Approved By"
                                ControlToValidate="cmbAprroved" Display="none" InitialValue="0" SetFocusOnError="true"
                                ValidationGroup="Items"> </asp:RequiredFieldValidator>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Batch No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtBatchNo" runat="server" MaxLength="50" Width="" TabIndex="2"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Category
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlCategory" runat="server" TabIndex="3"
                                Width="">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                SubCategory
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlSubcategory" runat="server" TabIndex="4"
                                Width="">
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <asp:CheckBox ID="ChkIsExpirable" runat="server" Checked="false"
                                Text="Expiry&nbsp;Dates" onclick="clicked()" />
                        </div>
                        <div class="col-md-5">
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                From Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="ucFromDate" Width="" runat="server" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="todalcal" TargetControlID="ucFromDate" Format="dd-MMM-yyyy"
                                runat="server">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                To Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                               <asp:TextBox ID="ucToDate" Width="" runat="server" ClientIDMode="Static" onchange="javascript:ValidateDate();"></asp:TextBox>
                        <cc1:CalendarExtender ID="todate" TargetControlID="ucToDate" Format="dd-MMM-yyyy"
                            runat="server">
                        </cc1:CalendarExtender>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                First Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                              <asp:TextBox ID="txtFirstNameSearch" AutoCompleteType="disabled" runat="server" Width="" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Item Code 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtCPTCodeSearch" runat="server" Width="" />
                        </div>
                        <div class="col-md-3">
                            <asp:Button ID="btnSearchItemCode" runat="server" Text="Search"
                              CssClass="ItDoseButton" OnClick="btnSearchItemCode_Click" />
                        </div>
                        
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Any Name 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <asp:TextBox ID="txtInBetweenSearch" runat="server" AutoCompleteType="Disabled" Width="" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                        </div>
                        <div class="col-md-21">
                            <asp:ListBox ID="lstItem" runat="server" Width="613px" TabIndex="6"
                            Height="167px"></asp:ListBox>
                        </div>
                    
                    </div>
                    <div class="row" style="text-align:center;">
                         <asp:Button ID="btnSearch" runat="server" CssClass="ItDoseButton" OnClick="btnSearch_Click"
                            TabIndex="7" Text="Search" />
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
            <table style="width: 100%; border-collapse: collapse">
                <tr style="display: none">
                    <td style="width: 100px; text-align: center">BarCode :
                    </td>
                    <td style="text-align: left">
                        <asp:TextBox ID="txtBar" runat="server"></asp:TextBox>
                        <asp:Button ID="btnBar" runat="server" OnClick="btnBar_Click" Text="Button" Height="0px"
                            Width="0px" CssClass="ItDoseButton" />
                    </td>
                    <td style="width: 100px; text-align: left"></td>
                </tr>
                <tr>
                    <asp:Panel ID="DGPnl" runat="server">
                        <td colspan="5">
                            <asp:GridView ID="DGGrid" runat="server" AllowPaging="True" AutoGenerateColumns="False" 
                                CssClass="GridViewStyle" Width="100%" OnSelectedIndexChanged="DGGrid_SelectedIndexChanged">
                                <Columns>
                                    <asp:TemplateField HeaderText="S.No.">
                                        <ItemTemplate>
                                            <%# Container.DataItemIndex+1 %>
                                        </ItemTemplate>
                                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Item Name">
                                        <ItemTemplate>
                                            <asp:Label ID="lblItemName" runat="server" Text='<%# Eval("ItemName") %>'></asp:Label>
                                        </ItemTemplate>
                                        <HeaderStyle Width="350px" CssClass="GridViewHeaderStyle" />
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="left" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Purchase Unit">
                                        <ItemTemplate>
                                            <asp:Label ID="PUnit" runat="server" Text='<%#Eval("MajorUnit") %>'></asp:Label>
                                        </ItemTemplate>
                                        <HeaderStyle Width="150px" CssClass="GridViewHeaderStyle" />
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="left" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="HSNCode">
                                        <ItemTemplate>
                                            <asp:Label ID="lblHSNCode" runat="server" Text='<%#Eval("HSNCode") %>'></asp:Label>
                                        </ItemTemplate>
                                        <HeaderStyle Width="150px" CssClass="GridViewHeaderStyle" />
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="left" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="IGST(%)">
                                        <ItemTemplate>
                                            <asp:Label ID="lblIGSTPer" runat="server" Text='<%#Eval("IGSTPercent") %>'></asp:Label>
                                        </ItemTemplate>
                                        <HeaderStyle Width="150px" CssClass="GridViewHeaderStyle" />
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="left" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="CGST(%)">
                                        <ItemTemplate>
                                            <asp:Label ID="lblCGSTPer" runat="server" Text='<%#Eval("CGSTPercent") %>'></asp:Label>
                                        </ItemTemplate>
                                        <HeaderStyle Width="150px" CssClass="GridViewHeaderStyle" />
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="left" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="SGST(%)">
                                        <ItemTemplate>
                                            <asp:Label ID="lblSGSTPer" runat="server" Text='<%#Eval("SGSTPercent") %>'></asp:Label>
                                        </ItemTemplate>
                                        <HeaderStyle Width="150px" CssClass="GridViewHeaderStyle" />
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="left" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Disc.(%)">
                                        <ItemTemplate>
                                            <asp:Label ID="lblDiscPer" runat="server" Text='<%#Eval("DiscPer") %>'></asp:Label>
                                        </ItemTemplate>
                                        <HeaderStyle Width="150px" CssClass="GridViewHeaderStyle" />
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="left" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Batch No.">
                                        <ItemTemplate>
                                            <asp:Label ID="lblBatchNo" runat="server" Text='<%#Eval("BatchNumber") %>'></asp:Label>
                                        </ItemTemplate>
                                        <HeaderStyle Width="150px" CssClass="GridViewHeaderStyle" />
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="left" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Unit Cost">
                                        <ItemTemplate>
                                            <asp:Label ID="lblUnitPrice" runat="server" Text='<%#Eval("UnitPrice") %>'></asp:Label>
                                        </ItemTemplate>
                                        <HeaderStyle Width="150px" CssClass="GridViewHeaderStyle" />
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="left" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Selling Price">
                                        <ItemTemplate>
                                            <asp:Label ID="lblMRP" runat="server" Text='<%#Eval("MRP") %>'></asp:Label>
                                        </ItemTemplate>
                                        <HeaderStyle Width="150px" CssClass="GridViewHeaderStyle" />
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="left" />
                                    </asp:TemplateField>
                                     <asp:TemplateField HeaderText="Quantity In Hand">
                                        <ItemTemplate>
                                            <asp:Label ID="lblQOH" runat="server" Text='<%#Eval("QOH") %>'></asp:Label>
                                        </ItemTemplate>
                                        <HeaderStyle Width="150px" CssClass="GridViewHeaderStyle" />
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="left" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Expiry Date">
                                        <ItemTemplate>
                                            <asp:Label ID="lblMedicalExpiryDate" runat="server" Text='<%# Eval("MedExpiryDate") %>'></asp:Label>
                                        </ItemTemplate>
                                        <HeaderStyle Width="100px" CssClass="GridViewHeaderStyle" />
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" />
                                    </asp:TemplateField>
                                    <asp:CommandField HeaderText="Select" ShowSelectButton="True" HeaderStyle-CssClass="GridViewHeaderStyle" HeaderStyle-HorizontalAlign="Center" ButtonType="Image" SelectImageUrl="~/Images/Post.gif">
                                        <ItemStyle HorizontalAlign="Center" Width="100px" CssClass="GridViewItemStyle" />
                                    </asp:CommandField>
                                    <asp:TemplateField Visible="false">
                                        <ItemTemplate>
                                            <asp:Label ID="lblItemID" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"ItemID") %>'
                                                Visible="False"></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField Visible="false">
                                        <ItemTemplate>
                                            <asp:Label ID="lblStockID" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"StockID") %>'
                                                Visible="False"></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </td>
                    </asp:Panel>
                    <asp:Panel ID="grdhide" runat="server">
                        <td colspan="5">
                            <asp:GridView ID="GridView1" runat="server" AllowPaging="True" AutoGenerateColumns="False"
                                CssClass="GridViewStyle" OnPageIndexChanging="GridView1_PageIndexChanging" OnSelectedIndexChanged="GridView1_SelectedIndexChanged"
                                Width="100%">
                                <Columns>
                                    <asp:TemplateField HeaderText="S.No.">
                                        <ItemTemplate>
                                            <%# Container.DataItemIndex+1 %>
                                        </ItemTemplate>
                                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Item Name">
                                        <ItemTemplate>
                                            <asp:Label ID="lblItemName" runat="server" Text='<%# Eval("ItemName") %>'></asp:Label>
                                        </ItemTemplate>
                                        <HeaderStyle Width="350px" CssClass="GridViewHeaderStyle" />
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="left" />
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="MajorUnit" HeaderText="Purchase Unit" HeaderStyle-CssClass="GridViewHeaderStyle" HeaderStyle-HorizontalAlign="Center">
                                        <ItemStyle HorizontalAlign="Center" Width="80px" CssClass="GridViewItemStyle" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="PurTaxPer" HeaderText="Purchase Tax(%)" HeaderStyle-CssClass="GridViewHeaderStyle" HeaderStyle-HorizontalAlign="Center">
                                        <ItemStyle HorizontalAlign="Center" Width="80px" CssClass="GridViewItemStyle" />
                                    </asp:BoundField>

                                      <asp:BoundField DataField="SaleTaxPer" HeaderText="Sale Tax(%)" HeaderStyle-CssClass="GridViewHeaderStyle" HeaderStyle-HorizontalAlign="Center">
                                        <ItemStyle HorizontalAlign="Center" Width="80px" CssClass="GridViewItemStyle" />
                                    </asp:BoundField>
                                  
                                    <asp:BoundField DataField="HSNCode" Visible="false" HeaderText="HSNCode" HeaderStyle-CssClass="GridViewHeaderStyle" HeaderStyle-HorizontalAlign="Center">
                                        <ItemStyle HorizontalAlign="Center" Width="80px" CssClass="GridViewItemStyle" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="IGSTPercent" Visible="false" HeaderText="IGST(%)" HeaderStyle-CssClass="GridViewHeaderStyle" HeaderStyle-HorizontalAlign="Center">
                                        <ItemStyle HorizontalAlign="Center" Width="80px" CssClass="GridViewItemStyle" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="CGSTPercent" Visible="false" HeaderText="CGST(%)" HeaderStyle-CssClass="GridViewHeaderStyle" HeaderStyle-HorizontalAlign="Center">
                                        <ItemStyle HorizontalAlign="Center" Width="80px" CssClass="GridViewItemStyle" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="SGSTPercent" Visible="false" HeaderText="SGST(%)" HeaderStyle-CssClass="GridViewHeaderStyle" HeaderStyle-HorizontalAlign="Center">
                                        <ItemStyle HorizontalAlign="Center" Width="80px" CssClass="GridViewItemStyle" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="DiscPer" HeaderText="Disc.(%)" HeaderStyle-CssClass="GridViewHeaderStyle" HeaderStyle-HorizontalAlign="Center">
                                        <ItemStyle HorizontalAlign="Center" Width="60px" CssClass="GridViewItemStyle" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="BatchNumber" HeaderText="Batch No." HeaderStyle-CssClass="GridViewHeaderStyle" HeaderStyle-HorizontalAlign="Center">
                                        <ItemStyle HorizontalAlign="Center" Width="125px" CssClass="GridViewItemStyle" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="UnitPrice" HeaderText="Unit Cost" HeaderStyle-CssClass="GridViewHeaderStyle" HeaderStyle-HorizontalAlign="Center">
                                        <ItemStyle HorizontalAlign="Right" Width="125px" CssClass="GridViewItemStyle" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="MRP" HeaderText="Selling Price" HeaderStyle-CssClass="GridViewHeaderStyle" HeaderStyle-HorizontalAlign="Center">
                                        <ItemStyle HorizontalAlign="Right" Width="150px" CssClass="GridViewItemStyle" />
                                    </asp:BoundField>
                                    <asp:TemplateField HeaderText="Quantity In Hand">
                                        <ItemTemplate>
                                            <asp:Label ID="lblQOH" runat="server" Text='<%# Eval("QOH") %>'></asp:Label>
                                        </ItemTemplate>
                                        <HeaderStyle Width="60px" CssClass="GridViewHeaderStyle" />
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Expiry Date">
                                        <ItemTemplate>
                                            <asp:Label ID="lblMedicalExpiryDate" runat="server" Text='<%# Eval("MedExpiryDate") %>'></asp:Label>
                                        </ItemTemplate>
                                        <HeaderStyle Width="100px" CssClass="GridViewHeaderStyle" />
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" />
                                    </asp:TemplateField>
                                    <asp:CommandField HeaderText="Select" ShowSelectButton="True" HeaderStyle-CssClass="GridViewHeaderStyle" HeaderStyle-HorizontalAlign="Center" ButtonType="Image" SelectImageUrl="~/Images/Post.gif">
                                        <ItemStyle HorizontalAlign="Center" Width="100px" CssClass="GridViewItemStyle" />
                                    </asp:CommandField>
                                    <asp:TemplateField Visible="false">
                                        <ItemTemplate>
                                            <asp:Label ID="lblItemID" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"ItemID") %>'
                                                Visible="False"></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField Visible="false">
                                        <ItemTemplate>
                                            <asp:Label ID="lblStockID" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"StockID") %>'
                                                Visible="False"></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                                <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Left" />
                                <RowStyle CssClass="GridViewItemStyle" />
                                <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                            </asp:GridView>
                        </td>
                    </asp:Panel>
                </tr>
            </table>
        </div>
        <asp:Panel ID="pnlInfo" runat="server">
            <div class="POuter_Box_Inventory" style="text-align: center;">
                  <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Items
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                              <asp:Label ID="lblItemName" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                               InHand Qty.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                                <asp:Label ID="lblQOH" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                               Expiry Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                                 <asp:Label ID="lblExpDate" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                        </div>
               </div>
                  <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Adjustment
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                                    <asp:TextBox ID="txtQty" runat="server" AutoCompleteType="Disabled" CssClass="ItDoseTextinputNum requiredField"
                                TabIndex="8" Width="250px" MaxLength="8" onkeypress="return checkForSecondDecimal(this,event)" onkeyup="validatedot();" ClientIDMode="Static"></asp:TextBox>&nbsp;
                            <span style="color: Red; font-size: 9px;"></span>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender2" runat="server" TargetControlID="txtQty"
                                FilterType="Custom, Numbers" ValidChars="." Enabled="True">
                            </cc1:FilteredTextBoxExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                              Narrations
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                               <asp:TextBox ID="txtNarration" CssClass="requiredField" runat="server" AutoCompleteType="Disabled"
                                TabIndex="8" Width="250px" MaxLength="150"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                              Quantity in Hand
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                                  <asp:TextBox ID="txtactualqty" runat="server" AutoCompleteType="Disabled"
                                TabIndex="8" Width="250px" MaxLength="150" onkeyup="changeqty(event);" ClientIDMode="Static"></asp:TextBox>
                        </div>
               </div>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center;">
                  <asp:Button ID="btnReturn" TabIndex="9" runat="server" CssClass="ItDoseButton" OnClick="btnReturn_Click" Text="Adjustment" Visible="False" />
              </div>
        </asp:Panel>
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <table>
                <tr style="text-align: left;">
                    <td colspan="4">
                        <asp:GridView ID="grdReturnItems" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                            Width="915px" OnRowCommand="grdReturnItems_RowCommand">
                            <Columns>
                                <asp:TemplateField HeaderText="S.No.">
                                    <ItemTemplate>
                                        <%# Container.DataItemIndex+1 %>
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                </asp:TemplateField>
                                <asp:BoundField DataField="ItemName" HeaderText="Item Name" HeaderStyle-CssClass="GridViewHeaderStyle" HeaderStyle-HorizontalAlign="Center">
                                    <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                </asp:BoundField>
                                <asp:BoundField DataField="MedExpiryDate" HeaderText="Expiry Date" HeaderStyle-CssClass="GridViewHeaderStyle" HeaderStyle-HorizontalAlign="Center">
                                    <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                </asp:BoundField>
                                <asp:BoundField DataField="BatchNumber" HeaderText="Batch No." HeaderStyle-CssClass="GridViewHeaderStyle" HeaderStyle-HorizontalAlign="Center">
                                    <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Rate" HeaderText="Rate" HeaderStyle-CssClass="GridViewHeaderStyle" HeaderStyle-HorizontalAlign="Center">
                                    <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Quantity" HeaderText="Quantity" HeaderStyle-CssClass="GridViewHeaderStyle" HeaderStyle-HorizontalAlign="Center">
                                    <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Amount" HeaderText="Amount" HeaderStyle-CssClass="GridViewHeaderStyle" HeaderStyle-HorizontalAlign="Center">
                                    <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                </asp:BoundField>
                                <asp:BoundField DataField="MRP" HeaderText="Selling Price" HeaderStyle-CssClass="GridViewHeaderStyle" HeaderStyle-HorizontalAlign="Center">
                                    <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                </asp:BoundField>

                                <asp:BoundField DataField="NetAmount" HeaderText="Net Amt." HeaderStyle-CssClass="GridViewHeaderStyle" HeaderStyle-HorizontalAlign="Center">
                                    <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                </asp:BoundField>
                                <asp:TemplateField HeaderText="Remove" HeaderStyle-HorizontalAlign="Center">
                                    <ItemTemplate>
                                        <asp:ImageButton ID="imbRemove" ToolTip="Remove Item" runat="server" ImageUrl="~/Images/Delete.gif"
                                            CausesValidation="false" CommandArgument='<%# Container.DataItemIndex %>' CommandName="imbRemove" />
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="55px" />
                                </asp:TemplateField>
                            </Columns>
                            <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Left" />
                        </asp:GridView>
                    </td>
                </tr>

            </table>
            <table style="width: 100%; text-align: center">
                <tr>
                    <td style="text-align: center;">
                        <asp:Button ID="btnAdjustment" Visible="false" runat="server" CssClass="ItDoseButton" OnClick="btnAdjustment_Click"
                            Text="Save" OnClientClick="return ButtonDisable(this)" />
                    </td>
                </tr>
            </table>

        </div>
    </div>
</asp:Content>
