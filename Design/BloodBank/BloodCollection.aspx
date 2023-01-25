<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="BloodCollection.aspx.cs" Inherits="Design_BloodBank_BloodCollection"
    EnableEventValidation="false" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script src="../../Scripts/Message.js" type="text/javascript" ></script>
       <script type="text/javascript">
        function pageLoad(sender, args) {
            if (!args.get_isPartialLoad()) {
                $addHandler(document, "keydown", onKeyDown);
            }
        }
        function onKeyDown(e) {
            if (e && e.keyCode == Sys.UI.Key.esc) {
                // if the key pressed is the escape key, dismiss the dialog
                $find('mpeCreateGroup').hide();
            }
        }
    </script>
    <script type="text/javascript">

        $(function () {
            var t = document.getElementById('<%=ddlCompleted.ClientID%>').value;
            if (t == 1) {

                document.getElementById("trDetail").style.display = '';
            }
            else
                document.getElementById("trDetail").style.display = 'none';
            //document.getElementById('<%=ddlQty1.ClientID%>').style.display = 'none';      
            $('#txtdatefrom').change(function () {
                ChkDate();

            });

            $('#txtdateTo').change(function () {
                ChkDate();

            });

            document.getElementById('<%=ddlQty.ClientID%>').style.display = 'none';
            $(".status").mouseover(function () {
                this.parentNode.parentNode.style.backgroundColor = 'cyan';
            });
            $(".status").mouseout(function () {
                this.parentNode.parentNode.style.backgroundColor = 'transparent';
            });
        });

        function ChkDate() {

            $.ajax({

                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#txtdatefrom').val() + '",DateTo:"' + $('#txtdateTo').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#<%=lblMsg.ClientID %>').text('To date can not be less than from date!');
                        $('#<%=btnSearch.ClientID %>').attr('disabled', 'disabled');

                        $('#<%=grdDonor.ClientID %>').hide();

                    }
                    else {
                        $('#<%=lblMsg.ClientID %>').text('');
                        $('#<%=btnSearch.ClientID %>').removeAttr('disabled');

                    }
                }
            });
        }

        function show() {
            document.getElementById('<%=ddlQty1.ClientID%>').style.display = '';
        }
        function show1() {
            document.getElementById('<%=ddlQty1.ClientID%>').style.display = 'none';

        }
        function clearAllField() {
            $(':text, textarea').val('');
        }

        function showDetail(str) {
            if (str.value == "1") {
                $('#hide').css("display", "none");
                $("#<%=ddlQty1.ClientID%>")[0].selectedIndex = 0;
                $("#<%=ddlQty.ClientID%>")[0].selectedIndex = 0;
                $("#<%=ddlBagType.ClientID %>")[0].selectedIndex = 0;
                document.getElementById("trDetail").style.display = '';
                $('#<%=Label1.ClientID %>').text(' ');
                bagtype2();
            }
            else {
                $('#hide').css("display", "");
                $('#<%=chkIsShocked.ClientID %>').show();
                $("#<%=ddlQty1.ClientID%>")[0].selectedIndex = 0;
                $("#<%=ddlQty.ClientID%>")[0].selectedIndex = 0;
                $("#<%=ddlBagType.ClientID %>")[0].selectedIndex = 0;
                bagtype2();
                document.getElementById("trDetail").style.display = 'none';
                $('#<%=Label1.ClientID %>').text(' ');
            }
        }
        function volumn(fld) {
            var a = fld.value;
            if (a < 0 || a > 450) {
                alert("Volumn In Between 0 To 450");

            }
        }
        function BagType() {

        }

        function Bagtype1() {
            var ddl = document.getElementById('<%=ddlBagType.ClientID%>');
            var ddltxt = ddl.options[ddl.selectedIndex].value;

            if (ddltxt != "0") {

                if (ddltxt == "1") {
                    $("#<%=lblvolumetype.ClientID %>").show();
                    $("#<%=ddlQty1.ClientID%>")[0].selectedIndex = 0;
                    $("#<%=ddlQty.ClientID%>")[0].selectedIndex = 0;
                    document.getElementById('<%=ddlQty1.ClientID%>').style.display = '';
                    document.getElementById('<%=ddlQty.ClientID%>').style.display = 'none';
                    $("#spnQty1").show();
                    $("#spnQty").hide();

                }
                else {
                    $("#<%=lblvolumetype.ClientID %>").show();
                    $("#<%=ddlQty1.ClientID%>")[0].selectedIndex = 0;
                    $("#<%=ddlQty.ClientID%>")[0].selectedIndex = 0;
                    document.getElementById('<%=ddlQty1.ClientID%>').style.display = 'none';
                    document.getElementById('<%=ddlQty.ClientID%>').style.display = '';
                    $("#spnQty").show();
                    $("#spnQty1").hide();
                }
            }
            else {
                $("#<%=lblvolumetype.ClientID %>,#<%=ddlQty1.ClientID%>,#spnQty1,#spnQty").hide();
                document.getElementById('<%=ddlQty.ClientID%>').style.display = 'none';
            }

        }
        $(document).ready(function () {
            bagtype2();
        });
        function bagtype2() {
            if ($("#<%=ddlBagType.ClientID %>").val() == "0") {
                $("#spnQty1,#spnQty,#<%=ddlQty1.ClientID %>,#<%=ddlQty.ClientID %>,#<%=lblvolumetype.ClientID %>").hide();
            }
            else {
                if ($("#<%=ddlBagType.ClientID %>").val() == "1") {
                    $("#<%=ddlQty1.ClientID %>,#<%=lblvolumetype.ClientID %>").show();
                    $("#<%=ddlQty.ClientID %>").hide();
                }
                else {
                    $("#<%=ddlQty1.ClientID %>").hide();
                    $("#<%=ddlQty.ClientID %>,#<%=lblvolumetype.ClientID %>").show();
                }
            }
        }
        function TABLE1_onclick() {

        }
        function validate() {
            var ddl = document.getElementById('<%=ddlBagType.ClientID%>');
            var ddltxt = ddl.options[ddl.selectedIndex].value;
            if ($('#<%=ddlCompleted.ClientID %>').val() == "0") {
                $('#<%=chkIsShocked.ClientID %>').attr('disabled', false);
                if ($('#<%=txtRemark.ClientID %>').val() == "") {
                    $('#<%=Label1.ClientID %>').text('Please Enter Remarks');
                    return false;
                }
                else {
                    if (Page_IsValid) {
                        document.getElementById('<%=Button1.ClientID%>').disabled = true;
                        document.getElementById('<%=Button1.ClientID%>').value = 'Submitting...';
                        __doPostBack('ctl00$ContentPlaceHolder1$Button1', '');
                    }
                    else {
                        document.getElementById('<%=Button1.ClientID%>').disabled = false;
                        document.getElementById('<%=Button1.ClientID%>').value = 'Save';
                    }

                }
            }
            else {
                $('#<%=chkIsShocked.ClientID %>').attr('disabled', true);
                if (ddltxt == "0") {
                    $('#<%=Label1.ClientID %>').text('Please Select Bag Type');
                    $("#<%=ddlBagType.ClientID %>").focus();
                    return false;
                }
                if (ddltxt == "1") {
                    if ($("#<%=ddlQty1.ClientID %>").val() == "Select") {
                        $('#<%=Label1.ClientID %>').text('Please Select Volume');
                        $("#<%=ddlQty1.ClientID %>").focus();
                        return false;
                    }
                }
                if (ddltxt != "1" && ddltxt != "0") {
                    if ($("#<%=ddlQty.ClientID %>").val() == "Select") {
                        $('#<%=Label1.ClientID %>').text('Please Select Volume');
                        $("#<%=ddlQty.ClientID %>").focus();
                        return false;
                    }
                }


                if ($('#<%=txtTubeNo.ClientID %>').val() == "") {
                    $('#<%=Label1.ClientID %>').text('Please Enter Tube No.');
                    $('#<%=txtTubeNo.ClientID %>').focus();
                    return false;
                }
                else {
                    if (Page_IsValid) {
                        document.getElementById('<%=Button1.ClientID%>').disabled = true;
                        document.getElementById('<%=Button1.ClientID%>').value = 'Submitting...';
                        __doPostBack('ctl00$ContentPlaceHolder1$Button1', '');
                    }
                    else {
                        document.getElementById('<%=Button1.ClientID%>').disabled = false;
                        document.getElementById('<%=Button1.ClientID%>').value = 'Save';
                    }

                }
            }
        }
    </script>
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>Blood Collection</b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div id="divResult" class="POuter_Box_Inventory" style="display: none;">
            <asp:Label ID="lblNewDonationId" runat="server" Text=""></asp:Label>
            <asp:Label ID="lblSession" runat="server" Text=""></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader" runat="server">
                Donor Search
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Donor ID 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtDonorId" runat="server" MaxLength="20" TabIndex="1"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Blood Group
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlBloodgroup" runat="server" TabIndex="2">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Donor Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtName" runat="server" MaxLength="50" TabIndex="3"></asp:TextBox>
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
                            <asp:TextBox ID="txtdatefrom" runat="server" ClientIDMode="Static" TabIndex="4"></asp:TextBox>
                            <cc1:CalendarExtender ID="calfrom" TargetControlID="txtdatefrom" Format="dd-MMM-yyyy"
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
                             <asp:TextBox ID="txtdateTo" runat="server" ClientIDMode="Static" TabIndex="5"></asp:TextBox>
                            <cc1:CalendarExtender ID="calto" TargetControlID="txtdateTo" Format="dd-MMM-yyyy"
                                Animated="true" runat="server">
                            </cc1:CalendarExtender>
                        </div>
                        
                        <div class="col-md-3">
                            <label class="pull-left">
                                Donor Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlDonorType" runat="server" TabIndex="6">
                               
                            </asp:DropDownList>
                        </div>
                       
                    </div>
                     <div class="row" style="display:none">
                    <div class="col-md-3">
                              <label class="pull-left">
                                Status
                            </label>
                            <b class="pull-right">:</b>

                        </div>
                       <div class="col-md-5">
                           <asp:CheckBox  ID="chkFailed" Text="Donation not completed" runat="server"/>
                      
                           </div>

                </div>
                </div>
               
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <asp:Button ID="btnSearch" runat="server" CssClass="ItDoseButton" Text="Search" TabIndex="6"
                OnClick="btnSearch_Click" />&nbsp;
        </div>
        <asp:Panel ID="pnlHide" runat="server" Visible="false">
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <asp:GridView ID="grdDonor" runat="server" AutoGenerateColumns="false" CssClass="GridViewStyle"
                    OnRowCommand="grdDonor_RowCommand" Width="100%">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField HeaderText="S.No." HeaderStyle-Width="25px" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <%#Container.DataItemIndex+1 %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Donor ID" HeaderStyle-Width="140px" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <asp:Label ID="lblDonorID" runat="server" Text='<%# Eval("Visitor_ID") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Bag Type" HeaderStyle-Width="100px" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <asp:Label ID="lblBagType" runat="server" Text='<%# Eval("BagType") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Bag Volume" HeaderStyle-Width="100px" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <asp:Label ID="lblQuantity" runat="server" Text='<%# Eval("Quantity") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Donor Name" HeaderStyle-Width="260px" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <asp:Label ID="lblName" runat="server" Text='<%# Eval("Name") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Sex" HeaderStyle-Width="70px" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <asp:Label ID="lblGender1" runat="server" Text='<%#Eval("Gender")%>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Group" HeaderStyle-Width="80px" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <asp:Label ID="lblGroup" runat="server" Text='<%# Eval("BloodGroup") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Reg. Date" HeaderStyle-Width="100px" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <%#Eval("dtentry")%>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Status" HeaderStyle-Width="70px" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <asp:ImageButton ID="imgResult" runat="server" ImageUrl="~/Images/Post.gif" CommandName="AResult"
                                    CommandArgument='<%# Eval("Visitor_ID")+"#"+Eval("Visit_ID") %>' CausesValidation="false"
                                    class="status" />
                                <%--<asp:Label ID="lblInvest" runat="server" Visible="false" Text='<%# Eval("Visitor_ID") %>'></asp:Label>--%>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>

            </div>
        </asp:Panel>
        <div style="display: none;">
            <asp:Button ID="btnHidden" runat="server" Text="Button" CssClass="ItDoseButton" />
        </div>
        <asp:Panel ID="pnlUpdate" Style="display: none" runat="server" CssClass="pnlSurgeryItemsFilter" Width="100%" Height="240px">
            <div class="Purchaseheader" id="dragUpdate" runat="server" style="width: 792px">
                Blood Collection Details : &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; Press esc to close
            </div>
            <div style="text-align: center;">
                <asp:Label ID="Label1" runat="server" CssClass="ItDoseLblError" />
            </div>
            <div style="text-align: center;">
                <asp:Label ID="lblVisitID" runat="server" Visible="False"></asp:Label>
                <asp:Label ID="lbldtentry" runat="server" Text="" Visible="False"></asp:Label>
                <table id="TABLE1" onclick="return TABLE1_onclick()" style="width: 795px">
                    <tr>
                        <td style="width: 80px; text-align: right">Donor ID :&nbsp;
                        </td>
                        <td style="width: 60px">
                            <asp:Label ID="lblVisitorID1" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                        </td>

                        <td style="width: 100Px; text-align: right">Name :&nbsp;
                        </td>
                        <td style="width: 100px; text-align: left">
                            <asp:Label ID="lblName1" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                        </td>
                        <td>&nbsp;
                        </td>
                        <td style="width: 100Px; text-align: right">Sex :&nbsp;
                        </td>
                        <td style="width: 60px; text-align: left">
                            <asp:Label ID="lblGender" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                        </td>
                        <td>&nbsp;
                        </td>
                        <td style="width: 110px; text-align: right">Blood Group :&nbsp;
                        </td>
                        <td style="width: 30px; text-align: left">
                            <asp:Label ID="lblGroup1" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 80px; text-align: right">Bag Type :&nbsp;
                        </td>
                        <td style="width: 60px; text-align: left">
                            <asp:Label ID="lblBagType" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                        </td>

                        <td style="width: 60Px; text-align: right">Qty. :&nbsp;
                        </td>
                        <td style="width: 100px; text-align: left">
                            <asp:Label ID="lblQty" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                        </td>
                        <td>&nbsp;
                        </td>
                        <td style="width: 100Px; text-align: right">Entry Date :&nbsp;
                        </td>
                        <td colspan="4" style="text-align: left">
                            <asp:Label ID="txtFromdate" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="11" style="text-align: right">
                            <asp:Label ID="Label2" runat="server" Text="(Expiry Date as per Entry Date)" Font-Bold="true"
                                ForeColor="red"></asp:Label>
                        </td>
                    </tr>
                </table>
            </div>
            <div style="border-style: solid; border-color: inherit; border-width: 1px; margin-right: 0px;">
                <div style="text-align: center; width: 771px;">
                    <div class="row">
                        <div class="col-md-5">
                            <label class="pull-left">Donation Completed</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <asp:DropDownList ID="ddlCompleted" runat="server" Width="" onchange="showDetail(this);"
                                    ValidationGroup="saveBloodCollection" TabIndex="1" ToolTip="Select Donation">
                                    <asp:ListItem Text="Select" Value="" Selected="True"></asp:ListItem>
                                    <asp:ListItem Text="Yes" Value="1"></asp:ListItem>
                                    <asp:ListItem Text="No" Value="0"></asp:ListItem>
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ValidationGroup="saveBloodCollection" ID="RequiredFieldValidator1"
                                    ControlToValidate="ddlCompleted" runat="server" ErrorMessage="*"></asp:RequiredFieldValidator>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Remark</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-11">
                              <asp:TextBox ID="txtRemark" runat="server" ValidationGroup="saveBloodCollection"
                                    Width="" TabIndex="5" ToolTip="Enter TubeNo" MaxLength="100"></asp:TextBox>
                                <asp:RequiredFieldValidator ValidationGroup="saveBloodCollection" ID="RequiredFieldValidator2"
                                    ControlToValidate="txtTubeNo" runat="server" ErrorMessage="Enter Remarks"></asp:RequiredFieldValidator>
                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" TargetControlID="txtRemark" runat="server" FilterType="LowercaseLetters,Numbers,UppercaseLetters"></cc1:FilteredTextBoxExtender>
                        </div>
                    </div>
                   <div class="row" id="trDetail" >
                        <div class="col-md-5">
                            <label class="pull-left">Bag Type</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlBagType" runat="server" TabIndex="3" ValidationGroup="saveBloodCollection"
                                    Width="" OnChange="Bagtype1();">
                                </asp:DropDownList>
                        </div>
                       <div class="col-md-3">
                            <asp:Label ID="lblvolumetype" Text="Volume&nbsp;&nbsp;&nbsp:" runat="server" CssClass="pull-left"></asp:Label>
                            <b class="pull-right"></b>
                        </div>
                        <div class="col-md-3">
                                <asp:DropDownList ID="ddlQty" runat="Server" TabIndex="4" ValidationGroup="saveBloodCollection"
                                    Width="65px" CssClass="requiredField">
                                    <asp:ListItem>Select</asp:ListItem>
                                    <asp:ListItem>350 ml</asp:ListItem>
                                    <asp:ListItem>450 ml</asp:ListItem>
                                </asp:DropDownList>
                                <span style="color: red; font-size: 10px; display: none" id="spnQty">*</span>
                                <asp:DropDownList ID="ddlQty1" runat="Server" TabIndex="4" ValidationGroup="saveQuestion"
                                    Width="65px">
                                    <asp:ListItem>Select</asp:ListItem>
                                    <asp:ListItem>350 ml</asp:ListItem>
                                </asp:DropDownList>
                                <span style="color: red; font-size: 10px; display: none" id="spnQty1"></span>
                        </div>
                       <div class="col-md-3">
                            <label class="pull-left">Tube No</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <asp:TextBox ID="txtTubeNo" runat="server" ValidationGroup="saveBloodCollection"
                                    Width="" TabIndex="5" ToolTip="Enter TubeNo" MaxLength="50" CssClass="requiredField"></asp:TextBox>
                                <span style="color: red; font-size: 10px; display:none">*</span>
                                <asp:RequiredFieldValidator ValidationGroup="saveBloodCollection" ID="RequiredFieldValidator3"
                                    ControlToValidate="txtTubeNo" runat="server" ErrorMessage="*"></asp:RequiredFieldValidator>
                                <cc1:FilteredTextBoxExtender ID="fteTube" TargetControlID="txtTubeNo" runat="server" FilterType="LowercaseLetters,Numbers,UppercaseLetters"></cc1:FilteredTextBoxExtender>
                           
                        </div>
                       </div>

                    <br />
                    <div style="float: right; margin-right: 30px;" id="hide">
                        <asp:CheckBox ID="chkIsShocked" runat="server" Text="Poor/Shocked Collection" />
                    </div>
                </div>
            </div>
            <div class="filterOpDiv" style="text-align: center;">
                <asp:Button ID="Button1" Text="Save" CssClass="ItDoseButton" runat="server" ValidationGroup="save"
                    OnClick="Button1_Click" OnClientClick="return validate();" ClientIDMode="Static"
                    UseSubmitBehavior="false" />&nbsp;&nbsp;&nbsp;
                <asp:Button ID="btnCancel" Text="Cancel" CssClass="ItDoseButton" runat="server" CausesValidation="False" />&nbsp;&nbsp;
            </div>
        </asp:Panel>
        <cc1:ModalPopupExtender ID="mpeCreateGroup" runat="server" CancelControlID="btnCancel"
            DropShadow="true" TargetControlID="btnHidden" BackgroundCssClass="filterPupupBackground"
            PopupControlID="pnlUpdate" PopupDragHandleControlID="pnlUpdate" BehaviorID="mpeCreateGroup">
        </cc1:ModalPopupExtender>
    </div>
</asp:Content>
