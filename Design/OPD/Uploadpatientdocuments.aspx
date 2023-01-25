<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="UploadPatientDocuments.aspx.cs" Inherits="Design_OPD_PatientDocumetnDetails" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" >
        $(document).ready(function () {
            $('#txtfromDate').change(function () {
                ChkDate();
            });

            $('#txtToDate').change(function () {
                ChkDate();
            });

        });

  

        function ChkDate() {

            $.ajax({

                url: "../Common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#txtfromDate').val() + '",DateTo:"' + $('#txtToDate').val() + '"}',
                type: "POST",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#<%=lblMsg.ClientID %>').text('To date can not be less than from date!');
                        $('#<%=btnSearch.ClientID %>').attr('disabled', 'disabled');
                        $('#<%=pnldetails.ClientID %>').hide();
                        $('#<%=hide.ClientID %>').hide();

                    }
                    else {
                        $('#lblMsg').text('');
                        $('#<%=btnSearch.ClientID %>').removeAttr('disabled');
                    }
                }
            });

        }

        $(document).ready(function () {
            AutoDoctor();
        });
        function AutoDoctor() {
            $(".a").hide();
            if ($("#<%=ddlDoctor.ClientID %> option:selected").text() == "All") {
                $(".a").hide();
                $("#<%= txtAppNo.ClientID%>").val('');
            }
            else {
                $(".a").show();
            }
        }
        function validate() {
            for (cnt = 0; cnt < gvchks.length; cnt++) {
                if (document.getElementById(gvchks[cnt]) && document.getElementById(gvchks[cnt]).checked) {
                    strFileName = document.getElementById(gvfls[cnt]).value;
                    if (strFileName == '') {
                        $("#<%=lblMsg.ClientID %>").text('Please Select File to Upload');
                        document.getElementById(gvfls[cnt]).focus();
                        return false;
                    }
                }

            }
            return true;
        }
    </script>
    <script type="text/javascript" >
       
</script>
    
    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" EnablePageMethods="true" runat="server"
        EnableScriptGlobalization="true" EnableScriptLocalization="true">
    </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Upload Patient Documents</b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Patient Search</div>
            <div style="text-align: center;">
                <table style="width: 100%;border-collapse:collapse">
                    <tr>
                        <td style="text-align: right">
                            Appointment Date From :&nbsp;
                        </td>
                        <td style="text-align: left">
                            <asp:TextBox ID="txtfromDate" runat="server" ToolTip="Click To Select From Date"
                                Width="130px" TabIndex="1" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="clcAppDate" runat="server" TargetControlID="txtfromDate"
                                Format="dd-MMM-yyyy" ClearTime="true">
                            </cc1:CalendarExtender>
                        </td>
                        <td>
                            &nbsp;
                        </td>
                        <td style="text-align: right">
                            Appointment Date To :&nbsp;
                        </td>
                        <td style="text-align: left">
                            <asp:TextBox ID="txtToDate" runat="server" ToolTip="Click To Select To Date" Width="130px"
                                TabIndex="2" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="txtCurrentDate0_CalendarExtender" runat="server" TargetControlID="txtToDate"
                                Format="dd-MMM-yyyy" ClearTime="true">
                            </cc1:CalendarExtender>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right">
                            Doctor Name :&nbsp;
                        </td>
                        <td style="text-align: left">
                            <asp:DropDownList ID="ddlDoctor" runat="server" onchange="AutoDoctor();" TabIndex="3"
                                ToolTip="Select Dotor Name" Width="136px">
                            </asp:DropDownList>
                        </td>
                        <td>
                            &nbsp;
                        </td>
                        <td style="text-align: right; display:none" class="a">
                            Appointment No. :&nbsp;
                        </td>
                        <td style="text-align: left;display:none" class="a">
                            <asp:TextBox ID="txtAppNo" runat="server" Width="130px" ToolTip="Enter Appointment No."></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right">
                            UHID :&nbsp;</td>
                        <td style="text-align: left">
                            <asp:TextBox ID="txtMrno" runat="server" Width="130px" ToolTip="Enter UHID"></asp:TextBox>
                        </td>
                        <td>
                            &nbsp;</td>
                        <td style="text-align: right;"  >
                            Patient Name :&nbsp;</td>
                        <td style="text-align: left;" >
                            <asp:TextBox ID="txtPname" runat="server" Width="130px" ToolTip="Enter Patient Name"></asp:TextBox>
                            </td>
                    </tr>
                    <tr>
                        <td style="text-align: right">
                            &nbsp;
                        </td>
                        <td style="text-align: left">
                            &nbsp;
                        </td>
                        <td>
                            <asp:Button ID="btnSearch" CssClass="ItDoseButton" runat="server" Text="Search" OnClick="btnSearch_Click" />
                        </td>
                        <td style="text-align: right">
                            &nbsp;
                        </td>
                        <td style="text-align: left">
                            &nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right">
                            &nbsp;
                        </td>
                        <td style="text-align: left">
                            &nbsp;
                        </td>
                        <td>
                            &nbsp;
                        </td>
                        <td style="text-align: right">
                            &nbsp;
                        </td>
                        <td style="text-align: left">
                            &nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td align="center" colspan="5">
                            <div>
                            </div>
                            <asp:Panel ID="pnldetails" runat="server" ScrollBars="Vertical" Height="200" Width="100%">
                                <asp:GridView ID="grdAppointment" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                                    OnRowCommand="grdAppointment_RowCommand">
                                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                                    <Columns>
                                        <asp:TemplateField HeaderText="S.No." ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-Width="20px"
                                            ItemStyle-Width="20px" HeaderStyle-CssClass="GridViewHeaderStyle">
                                            <ItemTemplate>
                                                <%# Container.DataItemIndex+1 %>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:BoundField DataField="App_ID" HeaderText="AppID" Visible="false">
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="AppNo" HeaderText="App. No.">
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Left" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="Name" HeaderText="Patient Name">
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="230px" HorizontalAlign="Left" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="DoctorName" HeaderText="Doctor Name">
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="230px" HorizontalAlign="Left" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="VisitType" HeaderText="Visit Type">
                                            <ItemStyle CssClass="GridViewItemStyle"    HorizontalAlign="Left"/>
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" HorizontalAlign="Left" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="AppTime" HeaderText="App. Time">
                                            <ItemStyle CssClass="GridViewItemStyle"  HorizontalAlign="Left"/>
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="90px" HorizontalAlign="Left" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="AppDate" HeaderText="App. Date">
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="90px" HorizontalAlign="Left" />
                                        </asp:BoundField>
                                        <asp:TemplateField HeaderText="View">
                                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                            <ItemTemplate>
                                                <asp:ImageButton ID="imgDetails" runat="server" CausesValidation="false" CommandName="AView"
                                                    ToolTip="Click To View Details" ImageUrl="~/Images/view.GIF" CommandArgument='<%# Eval("App_ID")+"#"+Eval("Name")+"#"+Eval("AppNo")+"#"+Eval("AppDate")  %>' />
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                            </asp:Panel>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <asp:Panel ID="hide" runat="server">
        <div id="divPatientDoc" runat="server">
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Research Details &nbsp;&nbsp;<span style="background-color: LightGreen">
                        &nbsp;Document Uploaded</span>&nbsp;&nbsp; <span style="background-color: LightPink">
                            Document Not Uploaded</span> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <asp:Label ID="lblNote" runat="server" Text="Note : Only pdf,jpg,jpeg,doc,docx,gif file accepted."></asp:Label>
                </div>
                
                <table style="width: 99%">
                    <tr>
                        <td style="text-align: right; width: 100px;">
                            Patient Name :
                        </td>
                        <td style="width: 180px;text-align:left">
                            <asp:Label ID="lblPatientName" runat="server" Style="color: #000099"></asp:Label>
                        </td>
                        <td style="text-align: right; width: 122px;">
                            Appointment No. :
                        </td>
                        <td style="width: 150px;text-align:left">
                            <asp:Label ID="lblAppointmentNo" runat="server" Style="color: #000099"></asp:Label>
                            <asp:Label ID="lblAppID" runat="server" Visible="false"></asp:Label>
                        </td>
                        <td style="text-align: right; width: 80px;">
                           Appointment&nbsp;Date :
                        </td>
                        <td style="text-align: left; width: 120px;">
                            <asp:Label ID="lblAppdate" runat="server" Style="color: #000099"></asp:Label>
                        </td>
                    </tr>
                </table>
                <br />
                <asp:GridView ID="grdDocDetails" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                    OnRowDataBound="grdDocDetails_RowDataBound" OnRowCommand="grdDocDetails_RowCommand">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField HeaderText="S.No.">
                            <ItemTemplate>
                                <%# Container.DataItemIndex+1 %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" HorizontalAlign="Center" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Research Form">
                            <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="400px" />
                            <ItemTemplate>
                                <asp:Label ID="lblStatus" runat="server" Visible="false" Text='<%# Eval("Status") %>' />
                                <asp:Label ID="lblTypeID" runat="server" Text='<%#Eval("FormID") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblID" runat="server" Text='<%#Eval("ID") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblName" runat="server" Text='<%#Eval("Name") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Upload">
                            <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                            <ItemTemplate>
                                <asp:FileUpload ID="ddlupload_doc" runat="server" />
                                <asp:Label ID="lblFilePath" Visible="false" runat="server" Text='<%#Eval("Url") %>'></asp:Label>
                                <asp:Label ID="lblFileName" Visible="false" runat="server" Text='<%#Eval("Imagename") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                             <asp:TemplateField HeaderText="Remarks">
                        <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                        <ItemTemplate>
                          <asp:TextBox ID="txtRemark" runat="server" Text='<%#Eval("Remark") %>'></asp:TextBox>
                            <asp:ImageButton ID="imgUpdateRemark" runat="server" ImageUrl="~/Images/Post.gif" 
                                CommandArgument='<%#Container.DataItemIndex +1%>' CommandName="UpdateRemark" Enabled='<%# Util.GetBoolean(Eval("Status")) %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                        <asp:TemplateField HeaderText="View">
                            <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                            <ItemTemplate>
                                <asp:Label ID="lblVisible" runat="server" Text='<%#Eval("visible") %>' Visible="false"></asp:Label>
                                <asp:ImageButton ID="imbView" runat="server" CausesValidation="false" CommandName="AView"
                                    Enabled='<%# Util.GetBoolean(Eval("FileStatus")) %>' ToolTip="Click To View Available Document"
                                    ImageUrl="~/Images/view.GIF" CommandArgument='<%# Eval("Url")  %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
            <div class="POuter_Box_Inventory">
                <div style="text-align: center">
                    <asp:Button ID="btnSave" runat="server"  CssClass="ItDoseButton"  ToolTip="Click to Upload" Text="Upload" OnClick="btnSave_Click" /></div>
            </div>
        </div>
        </asp:Panel>
    </div>
</asp:Content>
