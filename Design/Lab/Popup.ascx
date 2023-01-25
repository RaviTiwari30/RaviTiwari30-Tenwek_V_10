<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Popup.ascx.cs" Inherits="Design_Lab_Popup" %>
<asp:HiddenField ID="hdnledgertransaction" runat="server" />
<asp:HiddenField ID="hdntestid" runat="server" />


<div id="Div4" class="modal show">
    <div class="modal-dialog">
        <div class="modal-content" style="width: 1100px;">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="AddReport" aria-hidden="true">×</button>
                <strong class="modal_header" style="font-size: 20px;">Add Report</strong>
            </div>
            <div class="modal-body">
            </div>
            <div class="modal-footer">
            </div>
        </div>
    </div>
</div>
<div id="AddReport" class="modal show">
    <div class="modal-dialog">
        <div class="modal-content" style="width: 1100px;">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="AddReport" aria-hidden="true">×</button>
                <strong class="modal_header" style="font-size: 20px;">Add Report</strong>
            </div>
            <div class="modal-body">
                <div class="row Purchaseheader">Add Report</div>
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">
                            Test
                        </label>
                        <b class="pull-right">:
                        </b>
                    </div>
                    <div class="col-md-13">
                        <asp:DropDownList ID="ddlTestsaddreport" runat="server" onchange="bindAttachment('DdlCall');"></asp:DropDownList>
                    </div>

                </div>
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">Select File</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <input type="file" id="fu_UploadAddReport" name="postedFile" class="required" />
                    </div>
                </div>
                <div class="row" style="text-align: center">
                    <input type="button" id="btnSaveAddreport" value="Upload" class="savebutton" />
                </div>
            </div>
            <div class="modal-footer">
                <div class="row">
                    <table id="grdaddreport" class="GridViewStyle" cellspacing="0" rules="all" border="1"   width="99%">
                        <tr>
                            <th class="GridViewHeaderStyle" scope="col" style="text-align: center;"></th>
                            <th class="GridViewHeaderStyle" scope="col" style="text-align: center;"></th>
                            <th class="GridViewHeaderStyle" scope="col" style="text-align: center;">File Name</th>
                            <th class="GridViewHeaderStyle" scope="col" style="text-align: center;">Uploaded By</th>
                            <th class="GridViewHeaderStyle" scope="col" style="text-align: center;">Date</th>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>
<div id="PatientSampleinfoPopup" class="modal show">
    <div class="modal-dialog">
        <div class="modal-content" style="width: 1200px;">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="PatientSampleinfoPopup" aria-hidden="true">×</button>
                <strong class="modal_header" style="font-size: 20px;">Sample Information</strong>
            </div>
            <div class="modal-body">
                <div class="Purchaseheader">Sample Info</div>
                <div class="row">
                    <div class="col-md-25">
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Visit No.
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5" style="text-align: left;">
                                <asp:Label ID="lblLabNo" runat="server" Text="Label" Width="217px"></asp:Label>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Sample Type
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5" style="text-align: left;">
                                <asp:Label ID="lblSampleType" runat="server" Text="Label" Width="217px"></asp:Label>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Patient Name
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5" style="text-align: left;">
                                <asp:Label ID="lblpname" runat="server" Text="Label" Width="217px"></asp:Label>
                            </div>
                        </div>
                        <div class="row">

                            <div class="col-md-3">
                                <label class="pull-left">
                                    Age / Sex
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5" style="text-align: left;">
                                <asp:Label ID="lblAge" runat="server" Text="Label" Width="217px"></asp:Label>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Phone/Mobile
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5" style="text-align: left;">
                                <asp:Label ID="lblMobile" runat="server" Text="" Width="217px"></asp:Label>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Department
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5" style="text-align: left;">
                                <asp:Label ID="lblDepartment" runat="server" Text="" Width="217px"></asp:Label>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Refer Doctor
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5" style="text-align: left;">
                                <asp:Label ID="lblRefDoctor" runat="server" Width="217px" Text=""></asp:Label>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    PCC Code
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5" style="text-align: left;">
                                <div id="Div1">
                                    <asp:Label ID="lblpanel" runat="server" Width="217px" Text=""></asp:Label>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Comments
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5" style="text-align: left;">
                                <asp:Label ID="lblComments" runat="server" Width="217px" Text=""></asp:Label>
                            </div>
                        </div>
                        <div class="row">

                            <div class="col-md-3">
                                <label class="pull-left">
                                    Barcode No.
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5" style="text-align: left;">
                                <div id="Div2">
                                    <asp:Label ID="lblVial" runat="server" Width="217px" Text=""></asp:Label>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    <asp:HyperLink ID="hlAttachment" runat="server" Style="font-weight: 700; display: none">View Attachments</asp:HyperLink>
                                    Bed Details 
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5" style="text-align: left;">
                                <asp:Label ID="lblBedDetails" runat="server"></asp:Label>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    DOB
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5" style="text-align: left;">
                                <div id="Div3">
                                    <asp:Label ID="llbob" runat="server"></asp:Label>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <asp:GridView ID="grdrequiredfile" runat="server" AutoGenerateColumns="False" BackColor="White" BorderColor="#CCCCCC" BorderStyle="None" BorderWidth="1px" CellPadding="3">
                                <Columns>
                                    <asp:TemplateField HeaderText="Sr No.">

                                        <ItemTemplate>
                                            <%# Container.DataItemIndex+1 %>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField HeaderText="Field Name" DataField="FieldName" />
                                    <asp:BoundField DataField="FieldValue" HeaderText="FieldValue" />
                                </Columns>
                                <FooterStyle BackColor="White" ForeColor="#000066" />
                                <HeaderStyle BackColor="#006699" Font-Bold="True" ForeColor="White" />
                                <PagerStyle BackColor="White" ForeColor="#000066" HorizontalAlign="Left" />
                                <RowStyle ForeColor="#000066" />
                                <SelectedRowStyle BackColor="#669999" Font-Bold="True" ForeColor="White" />
                                <SortedAscendingCellStyle BackColor="#F1F1F1" />
                                <SortedAscendingHeaderStyle BackColor="#007DBB" />
                                <SortedDescendingCellStyle BackColor="#CAC9C9" />
                                <SortedDescendingHeaderStyle BackColor="#00547E" />
                            </asp:GridView>
                        </div>

                        <div class="col-md-1"></div>
                    </div>

                </div>
                <div style="text-align: center;">

                    <div class="Purchaseheader">Test List</div>
                    <div style="width: 1187px; height: 250px; overflow-y: scroll;">
                        <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="grdTestDetails" style="width: 100%; border-collapse: collapse;">
                            <tr>
                                <th class="GridViewHeaderStyle" scope="col" style="text-align: center;">Investigation Name</th>
                                <th class="GridViewHeaderStyle" scope="col" style="text-align: center;">Sample Drawn Date</th>
                                <th class="GridViewHeaderStyle" scope="col" style="text-align: center;">Work Order By</th>
                                <th class="GridViewHeaderStyle" scope="col" style="text-align: center;">Registration Date</th>
                                <th class="GridViewHeaderStyle" scope="col" style="text-align: center;">Registered By</th>
                                <th class="GridViewHeaderStyle" scope="col" style="text-align: center;">Received Date</th>
                                <th class="GridViewHeaderStyle" scope="col" style="text-align: center;">Received By</th>
                                <th class="GridViewHeaderStyle" scope="col" style="text-align: center;">Rejected Date</th>
                                <th class="GridViewHeaderStyle" scope="col" style="text-align: center;">Rejected By</th>
                                <th class="GridViewHeaderStyle" scope="col" style="text-align: center;">Sample Rejected Reason</th>
                                <th class="GridViewHeaderStyle" scope="col" style="text-align: center;">Result Entered Date</th>
                                <th class="GridViewHeaderStyle" scope="col" style="text-align: center;">Result Entered By</th>
                                <th class="GridViewHeaderStyle" scope="col" style="text-align: center;">Approved Date</th>
                                <th class="GridViewHeaderStyle" scope="col" style="text-align: center;">Approved By</th>
                                <th class="GridViewHeaderStyle" scope="col" style="text-align: center; display: none;">Approved Done By</th>
                                <th class="GridViewHeaderStyle" scope="col" style="text-align: center;">Hold By</th>
                                <th class="GridViewHeaderStyle" scope="col" style="text-align: center;">Hold Reason</th>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
            </div>
        </div>
    </div>
</div>
<div id="AddFile" class="modal show">
    <div class="modal-dialog">
        <div class="modal-content" style="width: 1100px;">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="AddFile" aria-hidden="true">×</button>
                <strong class="modal_header" style="font-size: 20px;">Add File</strong>
            </div>
            <div class="modal-body">
                <div class="row Purchaseheader">Add File</div>
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">
                            UHID
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:Label ID="lblUHID" runat="server" ClientIDMode="Static"> </asp:Label>
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">Patient Name</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:Label ID="lblPatientName" runat="server" ClientIDMode="Static"></asp:Label>
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">
                            Barcode No.
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:Label ID="lblBarcodeNo" runat="server" Style="color: blue;" ClientIDMode="Static"></asp:Label>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">
                            Document Type
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:TextBox ID="txtDocumentName" runat="server" AutoCompleteType="Disabled" CssClass="required"></asp:TextBox>
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">
                            Select File
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <input type="file" id="postedFile" name="postedFile" class="required" />
                    </div>
                </div>
                <div class="row" style="text-align: center">
                    <input type="button" id="btnUpload" value="Upload" class="savebutton" />
                </div>
            </div>
            <div class="modal-footer">
                <div class="row">
                    <table id="grvAttachment" class="GridViewStyle" cellspacing="0" rules="all" border="1"   width="99%">
                        <tr>
                            <th class="GridViewHeaderStyle" scope="col" style="text-align: center;"></th>
                            <th class="GridViewHeaderStyle" scope="col" style="text-align: center;">File Name</th>
                            <th class="GridViewHeaderStyle" scope="col" style="text-align: center;">Uploaded By</th>
                            <th class="GridViewHeaderStyle" scope="col" style="text-align: center;">Date</th>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>
<div id="DivPatientPrescription" class="modal show">
    <div class="modal-dialog">
        <div class="modal-content" style="width: 1100px;">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="DivPatientPrescription" aria-hidden="true">×</button>
                <strong class="modal_header" style="font-size: 20px;">Patient Prescription Detail</strong>
            </div>
            <div class="modal-body">
                <div class="row Purchaseheader">Patient Prescription Detail</div>
                  <div class="row">
                <div id="divList" style="max-height: 400px; overflow-x: auto">
                    <table class="FixedHeader" id="tblPrescriptionDetail" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse">
                        <thead>
                            <tr>
                                <th class="GridViewHeaderStyle" style="width: 30px;">SrNo</th>
                                <th class="GridViewHeaderStyle">UHID</th>
                                <th class="GridViewHeaderStyle">PName</th>
                                <th class="GridViewHeaderStyle">DoctorName</th>
                                <th class="GridViewHeaderStyle">DrDepartment</th>
                                <th class="GridViewHeaderStyle">PrescriptionDate</th>
                                <th class="GridViewHeaderStyle">View</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
            </div>
            <div class="modal-footer">
                
            </div>
        </div>
    </div>
</div>

<div id="AddRemarks_PatientTestPopup" class="modal show">
    <div class="modal-dialog">
        <div class="modal-content" style="width: 1100px;">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="AddRemarks_PatientTestPopup" aria-hidden="true">×</button>
                <strong class="modal_header" style="font-size: 20px;">Add New Remarks</strong>
            </div>
            <div class="modal-body">
                <div class="row Purchaseheader">Add New Remarks</div>
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">
                            Test Name
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-12">
                        <asp:Label ID="lblTestName" runat="server" ClientIDMode="Static"> </asp:Label>
                    </div>
                </div>
                <div>
                    <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_grdPatientremarks"
                        style="width: 100%; border-collapse: collapse;">
                        <thead>
                            <tr>
                                <th class="GridViewHeaderStyle" scope="col" style="display: none;">ID</th>
                                <th class="GridViewHeaderStyle" scope="col">Sr.No</th>
                                <th class="GridViewHeaderStyle" scope="col">Date</th>
                                <th class="GridViewHeaderStyle" scope="col">User ID</th>
                                <th class="GridViewHeaderStyle" scope="col">User Name</th>
                                <th class="GridViewHeaderStyle" scope="col">Remarks</th>
                                <th class="GridViewHeaderStyle" scope="col">Show Online</th>
                                <th class="GridViewHeaderStyle" scope="col">Add</th>
                                <th class="GridViewHeaderStyle" scope="col" style="display: none">Remove</th>
                            </tr>

                        </thead>
                        <tbody>
                            <tr id="tr_Data">
                                <td></td>
                                <td id="td_Date"><%=CurrentDataTimeDisp %></td>
                                <td id="td_UserID"><%=Session["ID"] %></td>
                                <td id="td_UserName"><%=Session["LoginName"] %></td>
                                <td id="td_Remarks">
                                    <input type="text" id="txtRamrks" style="display: none;" autocomplete="off" />
                                    <asp:DropDownList ID="ddlRemarks" runat="server" onchange="setRemarks();">
                                        <asp:ListItem Value="Sample Rejected" Text="Sample Rejected"></asp:ListItem>
                                        <asp:ListItem Value="CHANGEBARCODE" Text="Change Barcode"></asp:ListItem>
                                        <asp:ListItem Value="Others" Text="Others"></asp:ListItem>
                                    </asp:DropDownList>

                                </td>
                                <td id="td_ShowOnLine">
                                    <input id="chkRemarks" type="checkbox" name="chkRemarks" />Show Online</td>
                                <td>
                                    <img src="../../images/ButtonAdd.png" onclick="SavePatientRemarks();" alt="Save" style="cursor: pointer;" /></td>
                                <%--<td></td>--%>
                            </tr>
                        </tbody>
                    </table>
                </div>

            </div>
            <div class="modal-footer">
            </div>
        </div>
    </div>
</div>

<div id="ImmunoChemistry" class="modal show">
    <div class="modal-dialog">
        <div class="modal-content" style="width: 1150px;">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="ImmunoChemistry" aria-hidden="true">×</button>
                <strong class="modal_header" style="font-size: 20px;">Immuno Chemistry</strong>
            </div>
            <div class="modal-body">
                <%--<div class="row Purchaseheader">Immuno Chemistry</div>--%>
                <div class="row">
                    <div class="col-md-6">
                        <div class="row Purchaseheader">Search Antibiotic</div>
                        <div class="row">
                            <asp:TextBox ID="txtsearch" runat="server" Width="99%"></asp:TextBox>
                        </div>
                        <div class="row">
                            <asp:ListBox ID="lstlist" runat="server" Width="99%" Height="262px" />
                        </div>
                    </div>
                    <div class="col-md-2" style="text-align: center;">
                        <div class="row" style="height: 134px;"></div>
                        <div class="row-6">
                            <input type="button" value=">>" onclick="addme()" class="searchbutton" />
                        </div>
                    </div>
                    <div class="col-md-16" style="border: 1px solid gray;">
                        <div class="row Purchaseheader" style="text-align: center; font-weight: bold;">
                            Selected Immuno-HistoChemistry Antibodies
                        </div>
                        <div class="row">
                            <div id="PatientLabSearchOutput" style="width: 99%; height: 219px; overflow: scroll;"></div>
                        </div>
                        <div class="row">
                            <div class="col-md-5">
                                <strong class="pull-left">Final Impression</strong>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-8">
                                <input type="text" id="txtinter" style="width: 558px;" maxlength="490" />
                                <div style="display: none;">
                                    <CKEditor:CKEditorControl ID="txtcomments" BasePath="~/ckeditor" runat="server" EnterMode="BR" Width="900" Height="150" Toolbar="Source|Bold|Italic|Underline|Strike|-|NumberedList|BulletedList|Outdent|Indent|-|JustifyLeft|JustifyCenter|JustifyRight|JustifyBlock|Font|FontSize|"></CKEditor:CKEditorControl>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div style="width: 99%; text-align: center;">
                                <%--<input type="button" value="Close" onclick="closeme()"  class="searchbutton" />--%>
                                &nbsp;
                                           <input type="button" onclick="savedata()" value="Save" class="searchbutton" />
                                &nbsp;
                                           <input type="button" onclick="printonly()" value="Print" class="searchbutton" />
                            </div>
                            <div class="row" style="height: 10px;"></div>
                        </div>
                    </div>


                </div>
            </div>
            <div class="modal-footer">
            </div>
        </div>
    </div>
</div>
<script type="text/javascript">
    function ViewDocument(url) {
        var url1 = "\\LABINVESTIGATION\\Documents\\" + url;
        window.open("ViewFile.aspx?FileUrl=" + url1 + "&Extension=pdf");
    }
    function ViewDocumentReport(url) {
        var url1 = "\\LABINVESTIGATION\\OutSourceLabReport\\" + url;
        window.open("ViewFile.aspx?FileUrl=" + url1 + "&Extension=pdf");
    }

</script>
<script type="text/javascript">
    $(function () {
        $('#btnUpload').click(function () {
            if ($('#<%=txtDocumentName.ClientID%>').val() == "") {
                modelAlert('Please Enter Document Name');
                return false;
            }
            if ($("#postedFile").val() == "") {
                modelAlert('Please Upload File');
                return false;
            }



            var patdetail = [];
            patdetail.push($('#lblUHID').text());
            patdetail.push($('#lblPatientName').text());
            patdetail.push($('#lblBarcodeNo').text());
            patdetail.push('<%=Session["ID"]%>');
            patdetail.push($('#<%=hdnledgertransaction.ClientID%>').val());
            patdetail.push($('#<%=txtDocumentName.ClientID%>').val());

            var fileUpload = $("#postedFile").get(0);
            var files = fileUpload.files;
            var test = new FormData();
            for (var i = 0; i < files.length; i++) {
                test.append(files[i].name, files[i]);
            }
            test.append("patdetail", patdetail);
            test.append("Flag", 'AddFile');
            $.ajax({
                url: "HandlerCS.ashx",
                type: "POST",
                contentType: false,
                processData: false,
                data: test,
                // dataType: "json",
                success: function (result) {
                    modelAlert(result.name, function () {
                        $('#<%=txtDocumentName.ClientID%>').val('')
                        $("#postedFile").val('');
                        fancypopup($('#<%=hdnledgertransaction.ClientID%>').val());
                    });
                },
                error: function (err) {
                    modelAlert(err.statusText);
                }
            });
        });
        //--------------- ADD Report
        $('#btnSaveAddreport').click(function () {

            if ($("#fu_UploadAddReport").val() == "") {
                modelAlert('Please Upload File');
                return false;
            }
            if ($('#<%=ddlTestsaddreport.ClientID%>').val() == "") {
                modelAlert('Error Occured Please Contact To Administrator');
                return false;
            }

            var patdetail = [];
            patdetail.push('<%=Session["ID"]%>');
            patdetail.push($('#<%=hdnledgertransaction.ClientID%>').val());
            patdetail.push($('#<%=ddlTestsaddreport.ClientID%>').val());
            patdetail.push('<%=Session["LoginName"]%>');
            patdetail.push('<%=Session["CentreID"]%>');
            patdetail.push('<%=Session["RoleID"]%>');

            var fileUpload = $("#fu_UploadAddReport").get(0);
            var files = fileUpload.files;
            var test = new FormData();
            for (var i = 0; i < files.length; i++) {
                test.append(files[i].name, files[i]);
            }
            test.append("patdetail", patdetail);
            test.append("Flag", 'Addreport');
            $.ajax({
                url: "HandlerCS.ashx",
                type: "POST",
                contentType: false,
                processData: false,
                data: test,
                // dataType: "json",
                success: function (result) {
                    modelAlert(result.name, function () {
                        $("#fu_UploadAddReport").val('');
                        bindAttachment($('#<%=ddlTestsaddreport.ClientID%>').val());
                    });
                },
                error: function (err) {
                    modelAlert(err.statusText);
                }
            });
        });
    })

    $("#fu_UploadAddReport").change(function () {
        //.doc,.docx,.pdf,.jpg.,png,.gif,.jpeg
        //var fileExtension = ['doc', 'docx', 'pdf', 'jpg', 'png', 'gif', 'jpeg'];
        var fileExtension = ['pdf'];
        if ($.inArray($(this).val().split('.').pop().toLowerCase(), fileExtension) == -1) {
            modelAlert("Only " + fileExtension.join(', ') + " files is allowed");
            $("#fu_UploadAddReport").val('');
        }
    });

    $("#postedFile").change(function () {
        //.doc,.docx,.pdf,.jpg.,png,.gif,.jpeg
        var fileExtension = ['doc', 'docx', 'pdf', 'jpg', 'png', 'gif', 'jpeg'];
        if ($.inArray($(this).val().split('.').pop().toLowerCase(), fileExtension) == -1) {
            modelAlert("Only " + fileExtension.join(', ') + " files is allowed");
            $("#postedFile").val('');
        }
    });
    function bindAttachment(TestID) {
        if (TestID == 'DdlCall') {
            TestID = $('#ctl00_ContentPlaceHolder1_popupctrl_ddlTestsaddreport option:selected').val();
        }

        serverCall('MachineResultEntry.aspx/bindAttachment', { TestID: TestID }, function (response) {
            var data = JSON.parse(response);
            var dtdetail = data.dtdetail;
            var grvAtt = "";
            $('#grdaddreport tr').slice(1).remove();
            for (var i = 0; i < dtdetail.length; i++) {

                grvAtt += '<tr>';
                if (dtdetail[i].Approved == "1") {
                    grvAtt += '<td></td>';
                }
                else {
                    grvAtt += '<td style="text-align:center;"><img alt="" src="../../Images/Delete.GIF" onclick="RemoveData(\'' + dtdetail[i].Test_ID + '\',\'' + dtdetail[i].FileUrl + '\')" /></td>';
                }
                grvAtt += '<td style="text-align:center;"><img alt="" src="../../Images/view.GIF" onclick="ViewDocumentReport(\'' + dtdetail[i].FileUrl + '\')" /></td>';
                grvAtt += '<td style="text-align:center;">' + dtdetail[i].FileUrl + '</td>';
                grvAtt += '<td style="text-align:center;">' + dtdetail[i].UploadedBy + '</td>';
                grvAtt += '<td style="text-align:center;">' + dtdetail[i].dtEntry + '</td>';
                grvAtt += '</tr>';
            }
            $('#grdaddreport').append(grvAtt);
        });
    }
    function fancypopuplst(LedgerTransactionNo) {
        fancypopup(LedgerTransactionNo);
    }
    function fancypopup(LedgerTransactionNo) {
        serverCall('MachineResultEntry.aspx/BindPatientDetails', { LedgerTransactionNo: LedgerTransactionNo }, function (response) {
            var data = JSON.parse(response);
            var PatientDetails = data.PatientDetails;
            $('#lblUHID').text(PatientDetails[0]["PatientID"])
            $('#lblPatientName').text(PatientDetails[0]["PName"])
            $('#lblBarcodeNo').text(PatientDetails[0]["BarcodeNo"])
            var grvAttachment = data.grvAttachment;
            var grvAtt = "";
            $('#grvAttachment tr').slice(1).remove();
            for (var i = 0; i < grvAttachment.length; i++) {
                grvAtt += '<tr>';
                grvAtt += '<td style="text-align:center;"><img alt="" src="../../Images/view.GIF" onclick="ViewDocument(\'' + grvAttachment[i].FileUrl + '\')" /></td>';
                grvAtt += '<td style="text-align:center;">' + grvAttachment[i].FileUrl + '</td>';
                grvAtt += '<td style="text-align:center;">' + grvAttachment[i].UploadedBy + '</td>';
                grvAtt += '<td style="text-align:center;">' + grvAttachment[i].Updatedate + '</td>';
                grvAtt += '</tr>';
            }
            $('#grvAttachment').append(grvAtt);
        });
        $('#ctl00_ContentPlaceHolder1_popupctrl_hdnledgertransaction').val(LedgerTransactionNo);
        $('#popupctrl_hdnledgertransaction').val(LedgerTransactionNo);
        $('#AddFile').show();
    }
    function AddReport(LedgerTransactionNo, _TestID) {
        //var href = 'addreport.aspx?LedgerTransactionNo=' + LedgerTransactionNo + '&Test_ID=' + _test_id;
        //fancypopup(href)

        $('#ctl00_ContentPlaceHolder1_popupctrl_hdnledgertransaction').val(LedgerTransactionNo);
        $('#ctl00_ContentPlaceHolder1_popupctrl_hdntestid').val(_TestID);
        $('#popupctrl_hdnledgertransaction').val(LedgerTransactionNo);
        $('#popupctrl_hdntestid').val(_TestID);
        serverCall('MachineResultEntry.aspx/BindTestDDL', { LedgerTransactionNo: LedgerTransactionNo, TestID: _TestID }, function (response) {
            var data = JSON.parse(response);
            var PatientDetails = data.PatientDetails;
            if (PatientDetails.length == 0) {
                modelAlert('This Test Is Not OutSource');
                return false;
            }
            $('#ctl00_ContentPlaceHolder1_popupctrl_ddlTestsaddreport option').remove()
            for (var i = 0; i < PatientDetails.length; i++) {
                $('#ctl00_ContentPlaceHolder1_popupctrl_ddlTestsaddreport').append($('<option></option>').html(PatientDetails[i]["Name"]).val(PatientDetails[i]["Test_ID"]));
                $('#popupctrl_ddlTestsaddreport').append($('<option></option>').html(PatientDetails[i]["Name"]).val(PatientDetails[i]["Test_ID"]));
            }
            bindAttachment(_TestID);
        });
        $('#AddReport').show();
    }
    function RemoveData(Test_ID, FileUrl) {
        serverCall('MachineResultEntry.aspx/RemoveData', { TestID: Test_ID, FileUrl: FileUrl }, function (response) {
            if (response == true) {
                modelAlert('File Deleted Successfully', function () {
                    bindAttachment(Test_ID);
                });
            }
        });

    }
    function CommonPatientinfo(LedgerTransactionNo, Test_ID, Flag) {
        serverCall('MachineResultEntry.aspx/Bindsampleinfo', { LedgerTransactionNo: LedgerTransactionNo, Test_ID: Test_ID }, function (response) {
            var data = JSON.parse(response);
            var dtdetail = data.SampleInfodt;
            var grvAtt = "";
            $('#grdTestDetails tr').slice(1).remove();
            if (Flag == "Other") {
                $('#ctl00_ContentPlaceHolder1_popupctrl_lblLabNo').text(dtdetail[0]["LedgerTransactionNo"]);
                $('#ctl00_ContentPlaceHolder1_popupctrl_lblSampleType').text(dtdetail[0]["SampleType"]);
                $('#ctl00_ContentPlaceHolder1_popupctrl_lblpname').text(dtdetail[0]["PName"]);
                $('#ctl00_ContentPlaceHolder1_popupctrl_lblAge').text(dtdetail[0]["Age"]);
                $('#ctl00_ContentPlaceHolder1_popupctrl_lblMobile').text(dtdetail[0]["Mobile"]);
                $('#ctl00_ContentPlaceHolder1_popupctrl_lblDepartment').text(dtdetail[0]["DepartmentName"]);
                $('#ctl00_ContentPlaceHolder1_popupctrl_lblRefDoctor').text(dtdetail[0]["ReferDoctor"]);
                $('#ctl00_ContentPlaceHolder1_popupctrl_lblpanel').text(dtdetail[0]["Panel_Code"]);
                $('#ctl00_ContentPlaceHolder1_popupctrl_lblComments').text(dtdetail[0]["Comments"]);
                $('#ctl00_ContentPlaceHolder1_popupctrl_lblVial').text(dtdetail[0]["BarcodeNo"]);
                $('#ctl00_ContentPlaceHolder1_popupctrl_lblBedDetails').text(dtdetail[0]["BedDetails"]);
                $('#ctl00_ContentPlaceHolder1_popupctrl_llbob').text(dtdetail[0]["DOB"]);
            }

            if (Flag == "HC") {
                $('#popupctrl_lblLabNo').text(dtdetail[0]["LedgerTransactionNo"]);
                $('#popupctrl_lblSampleType').text(dtdetail[0]["SampleType"]);
                $('#popupctrl_lblpname').text(dtdetail[0]["PName"]);
                $('#popupctrl_lblAge').text(dtdetail[0]["Age"]);
                $('#popupctrl_lblMobile').text(dtdetail[0]["Mobile"]);
                $('#popupctrl_lblDepartment').text(dtdetail[0]["DepartmentName"]);
                $('#popupctrl_lblRefDoctor').text(dtdetail[0]["ReferDoctor"]);
                $('#popupctrl_lblpanel').text(dtdetail[0]["Panel_Code"]);
                $('#popupctrl_lblComments').text(dtdetail[0]["Comments"]);
                $('#popupctrl_lblVial').text(dtdetail[0]["BarcodeNo"]);
                $('#popupctrl_lblBedDetails').text(dtdetail[0]["BedDetails"]);
                $('#popupctrl_llbob').text(dtdetail[0]["DOB"]);
            }


            for (var i = 0; i < dtdetail.length; i++) {
                grvAtt += '<tr>';
                grvAtt += '<td scope="col" style="text-align:center;">' + dtdetail[i].name + '</td>';
                grvAtt += '<td scope="col" style="text-align:center;">' + dtdetail[i].HomeCollectionDate + '  </td>';
                grvAtt += '<td scope="col" style="text-align:center;">' + dtdetail[i].WorkOrderBy + '  </td>';
                grvAtt += '<td scope="col" style="text-align:center;">' + dtdetail[i].SegratedDate + '  </td>';
                grvAtt += '<td scope="col" style="text-align:center;">' + dtdetail[i].SampleCollector + '  </td>';
                grvAtt += '<td scope="col" style="text-align:center;">' + dtdetail[i].SampleReceiveDate + '  </td>';
                grvAtt += '<td scope="col" style="text-align:center;">' + dtdetail[i].SampleReceivedBy + '  </td>';
                grvAtt += '<td scope="col" style="text-align:center;">' + dtdetail[i].RejectDate + '  </td>';
                grvAtt += '<td scope="col" style="text-align:center;">' + dtdetail[i].RejectUser + '  </td>';
                grvAtt += '<td scope="col" style="text-align:center;">' + dtdetail[i].RejectionReason + '  </td>';
                grvAtt += '<td scope="col" style="text-align:center;">' + dtdetail[i].ResultEnteredDate + '  </td>';
                grvAtt += '<td scope="col" style="text-align:center;">' + dtdetail[i].ResultEnteredName + '  </td>';
                grvAtt += '<td scope="col" style="text-align:center;">' + dtdetail[i].ApprovedDate + '  </td>';
                grvAtt += '<td scope="col" style="text-align:center;">' + dtdetail[i].ApprovedName + '  </td>';
                grvAtt += '<td scope="col" style="text-align:center;display:none;"  >' + dtdetail[i].ApprovedDoneBy + '  </td>';
                grvAtt += '<td scope="col" style="text-align:center;">' + dtdetail[i].holdByName + '  </td>';
                grvAtt += '<td scope="col" style="text-align:center;">' + dtdetail[i].Hold_Reason + '  </td>';
                grvAtt += '</tr>';
            }
            $('#grdTestDetails').append(grvAtt);
        });
        $('#PatientSampleinfoPopup').show();
    }
    $("#btnPatientDetail").click(function () {
        CommonPatientinfo(PatientData[currentRow].LedgerTransactionNo, PatientData[currentRow].Test_ID, 'Other')
    });
</script>

<script type="text/javascript">
    var $labno = "";
    var $TestID = "";
    var $TestName = "";
    var $Offline = "";
    var $Flag = "";
    function AddRemarks(labno, TestID, _TestName, Offline, Flag) {
        $labno = labno;
        $TestID = TestID;
        $TestName = _TestName;
        $Offline = Offline;
        $Flag = Flag;
        var Offline = $Offline;
        if (Offline == '1') {
            $('#chkRemarks').attr('checked', 'checked');
            $('#chkRemarks').attr('disabled', 'disabled');
        }
        else {
            $('#chkRemarks').removeAttr('checked');
            $('#chkRemarks').removeAttr('disabled');
        }
        GetRemarks();
        $('#AddRemarks_PatientTestPopup').show();
        $('#lblTestName').text(_TestName);
    }
    function GetRemarks() {
        var lastRow = $('#tb_grdPatientremarks tbody tr#tr_Data').html();
        $('#tb_grdPatientremarks tr').slice(1).remove();
        var TestID = $TestID;
        var Offline = $Offline;
        $.ajax({
            url: "AddRemarks_PatientTestPopup.aspx/GetRemarks",
            data: '{TestID:"' + TestID + '",Offline:"' + Offline + '"}', // parameter map
            type: "POST", // data has to be Posted    	        
            contentType: "application/json; charset=utf-8",
            timeout: 120000,
            dataType: "json",
            success: function (result) {
                RemarksData = $.parseJSON(result.d);
                for (var i = 0; i <= RemarksData.length - 1; i++) {
                    var mydata = "<tr>";
                    mydata += "<td>" + (RemarksData.length - (i)) + "</td>";
                    mydata += "<td>" + RemarksData[i].DATE + "</td>";
                    mydata += "<td>" + RemarksData[i].UserID + "</td>";
                    mydata += "<td>" + RemarksData[i].UserName + "</td>";
                    mydata += "<td>" + RemarksData[i].Remarks + "</td>";
                    mydata += "<td>" + RemarksData[i].ShowOnline + "</td>";
                    mydata += "<td></td>";
                    mydata += "<td style='display:none'><img src='../../images/Delete.gif' style='cursor:pointer;' onclick='DeleteRemarks(" + RemarksData[i].ID + ");' /></td>";
                    mydata += "</tr>";
                    $('#tb_grdPatientremarks').prepend(mydata);
                }
                $('#tb_grdPatientremarks').append('<tr id="tr_Data">' + lastRow + '</tr>');
            },
            error: function (xhr, status) {
                modelAlert("Error");
                window.status = status + "\r\n" + xhr.responseText;
            }
        });
    }

    function SavePatientRemarks() {
        var TestID = $TestID;
        var Remarks = '';
        if ($('#<%=ddlRemarks.ClientID%>').val() == "Others" || $('#<%=ddlRemarks.ClientID%>').val() == "CHANGEBARCODE") {
            if ($Flag == "HC") {
                Remarks = $('#tb_grdPatientremarks tr#tr_Data').find('#popupctrl_ddlRemarks').val() + " Remarks : " + $('#txtRamrks').val();
            }
            else {
                Remarks = $('#tb_grdPatientremarks tr#tr_Data').find('#ctl00_ContentPlaceHolder1_popupctrl_ddlRemarks').val() + " Remarks : " + $('#txtRamrks').val();
            }

        }
        else {
            if ($Flag == "HC") {
                Remarks = $('#tb_grdPatientremarks tr#tr_Data').find('#popupctrl_ddlRemarks').val();
            }
            else {
                Remarks = $('#tb_grdPatientremarks tr#tr_Data').find('#ctl00_ContentPlaceHolder1_popupctrl_ddlRemarks').val();
            }
        }
        if (Remarks == 'CHANGEBARCODE Remarks : ' || Remarks == 'Others Remarks : ') {
            modelAlert('Please Enter Remarks')
            return;
        }
        var VisitNo = $labno;
        var ShowOnline = 0;
        if ($('#tb_grdPatientremarks tr#tr_Data').find('#chkRemarks').prop('checked'))
            ShowOnline = 1;
        var Offline = $Offline;
        $.ajax({
            url: "AddRemarks_PatientTestPopup.aspx/SavePatientRemarks",
            data: '{TestID:"' + TestID + '",Remarks:"' + Remarks + '",VisitNo:"' + VisitNo + '",ShowOnline:"' + ShowOnline + '",Offline:"' + Offline + '"}', // parameter map
            type: "POST", // data has to be Posted    	        
            contentType: "application/json; charset=utf-8",
            timeout: 120000,
            dataType: "json",
            success: function (result) {
                if (result.d == '0') {
                    modelAlert("Remarks Not Saved Successfully");
                }
                else {
                    //  modelAlert('Remarks Saved Successfully');
                    modelAlert('Remarks Saved Successfully', function (response) {
                        $('#txtRamrks').hide();
                        GetRemarks();
                    });

                }
            },
            error: function (xhr, status) {
                modelAlert("Error");
                window.status = status + "\r\n" + xhr.responseText;
            }
        });
    }
    function DeleteRemarks(ID) {
        $.ajax({
            url: "AddRemarks_PatientTestPopup.aspx/DeleteRemarks",
            data: '{ID:"' + ID + '"}', // parameter map
            type: "POST", // data has to be Posted    	        
            contentType: "application/json; charset=utf-8",
            timeout: 120000,
            dataType: "json",
            success: function (result) {
                if (result.d == '0') {
                    modelAlert("Remarks Not Removed Successfully");
                }
                else {
                    GetRemarks();
                }
            },
            error: function (xhr, status) {
                modelAlert("Error ");
                window.status = status + "\r\n" + xhr.responseText;
            }
        });
    }
    function setRemarks() {
        $('#txtRamrks').val('');
        if ($('#<%=ddlRemarks.ClientID%>').val() == "Others" || $('#<%=ddlRemarks.ClientID%>').val() == "CHANGEBARCODE") {
               $('#txtRamrks').show();
               $('#txtRamrks').focus();
           }
           else {
               $('#txtRamrks').hide();
           }
       }
</script> 
<script type="text/javascript">

    function PrescriptionDetail(PatientID) {
        serverCall('MachineResultEntry.aspx/BindPatientPrecriptionDetails', { PatientID: PatientID }, function (response) {
            var data = JSON.parse(response);
            if (data.length > 0) {
                $('#DivPatientPrescription').show();

                $('#tblPrescriptionDetail tbody').empty();
                for (var i = 0; i < data.length; i++) {
                    var j = $('#tblPrescriptionDetail tbody tr').length + 1;
                    var row = '<tr>';
                    row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';
                    row += '<td id="tdPatientID" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].PatientID + '</td>';
                    row += '<td id="tdPname" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Pname + '</td>';
                    row += '<td id="tdDName" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].DName + '</td>';
                    row += '<td id="tdSpecialization" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Specialization + '</td>';
                    row += '<td id="tdPrescriptionDate" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].PrescriptionDate + '</td>';
                    row += '<td style="text-align:center" class="GridViewLabItemStyle" ><a target="_blank" href="InvestigationMobile.aspx?TID=' + data[i].PrescriptionDetail.split('#')[0] + '&amp;LnxNo=' + data[i].PrescriptionDetail.split('#')[2] + '&amp;IsDone=1&amp;Patient_ID=' + data[i].PatientID + '&amp;App_ID=' + data[i].PrescriptionDetail.split('#')[3] + '>&amp;PanelID=' + data[i].PrescriptionDetail.split('#')[4] + '&amp;DoctorID=' + data[i].PrescriptionDetail.split('#')[1] + '&amp;isViwedPatient=1"><img alt="Select" src="../../Images/view.GIF" style="border: 0px solid #FFFFFF;" /></a>  </td>';
                    row += '</tr>';
                    $('#tblPrescriptionDetail tbody').append(row);
                }
            }
            else { modelAlert(" No Prescription Details Found "); }

        });
    }


    var values = [];
    var PatientData = "";
    var TestID = '';
        var LabNo = '';
       
    function ImmunoChemistry(LabNum,Tstid) {
        TestID = Tstid;
        LabNo = LabNum;
        serverCall('HistoImmunoChemistry.aspx/gettext', { TestID: TestID, LabNo: LabNo }, function (response) {
            if (response !="") {
                response = JSON.parse(response)
                var objEditor = CKEDITOR.instances['<%=txtcomments.ClientID%>'];
                objEditor.val(response);
            } 
           
        });
        $('#ImmunoChemistry').show();
        var output = $('#tb_PatientLabSearchImmuno').parseTemplate(PatientData);
        $('#PatientLabSearchOutput').html(output);

        
        getdata();
        var options = $('#<% = lstlist.ClientID %> option');
            $.each(options, function (index, item) {
                values.push(item.innerHTML);
            });


            $('#<% = txtsearch.ClientID %>').keyup(function (e) {

                var key = (e.keyCode ? e.keyCode : e.charCode);


                if (key == 38 || key == 40) {
                    var index = $('#<% = lstlist.ClientID %>').get(0).selectedIndex;
                    if (key == 38)
                        $('#<% = lstlist.ClientID %> ').attr('selectedIndex', index - 1);
                    else if (key == 40)
                        $('#<% = lstlist.ClientID %> ').attr('selectedIndex', index + 1);

                $('#<% = txtsearch.ClientID %>').val($('#<% = lstlist.ClientID %> :selected').text());
                }
                else {
                    var filter = $(this).val();
                    if (filter == '') {
                        $('#<% = lstlist.ClientID %> option:nth-child(1)').attr('selected', 'selected');


                        return;
                    }
                    DoListBoxFilter('#<% = lstlist.ClientID %>', '#<% = txtsearch.ClientID %>', "0", filter, values);
                }


            });

        }

        function DoListBoxFilter(listBoxSelector, textbox, searchtype, filter, values) {



            var list = $(listBoxSelector);
            var selectBase = '<option value="{0}">{1}</option>';



            if (searchtype == "0") {
                for (i = 0; i < values.length; ++i) {

                    var value = values[i].trim();




                    var len = $(textbox).val().length;
                    if (value.substring(0, len).toLowerCase() == filter.toLowerCase()) {
                        list.attr('selectedIndex', i);

                        return;
                    }
                }
            }



            $(textbox).focus();

        }

        function addme() {

            if ($("#<%=lstlist.ClientID%>").attr('selectedIndex') == -1) {
                modelAlert("Please Select Item From List");
                return;
            }
            var dup = 0;

            $('#tb_grdLabSearchImmuno tr').each(function () {
                if ($(this).attr("id") != "header") {
                    if ($(this).find("#antiname").html() == $('#<%=lstlist.ClientID%> option:selected').text()) {
                        dup = 1;
                        return;
                    }
                }
            });

            if (dup == 1) {
                alert("Antibodies Already In List..!");
                return;
            }
            $('#<%=lstlist.ClientID%> option:selected').text()

            var a = $('#tb_grdLabSearchImmuno tr').length - 1;
            var mydata = "<tr style='height:30px;'>";
            mydata += '<td>' + parseFloat(a + 1) + '</td>';
            mydata += '<td id="antiname" align="left">' + $('#<%=lstlist.ClientID%> option:selected').text() + '</td>';
            mydata += '<td id="antiid" align="left" style="display:none;">' + $('#<%=lstlist.ClientID%> option:selected').val() + '</td>';

            mydata += ' <td  id="clone"><input class="oobbss1" type="text" style="width:80px;"  />   </td>';
            mydata += '<td  id="type"><input class="oobbss2" type="text" style="width:80px;"  />   </td>';
            mydata += '<td  id="result"><input class="oobbss3" type="text" style="width:80px;"  />   </td>';
            mydata += '<td  id="intensity"><input class="oobbss4" type="text" style="width:80px;"  />   </td>';
            mydata += '<td  id="pattern"><input class="oobbss5" type="text" style="width:80px;"  />   </td>';
            mydata += '<td  id="percentage"><input class="oobbss6" type="text" style="width:80px;"  />   </td>';
            mydata += '<td><img src="../../Images/Delete.GIF" style="cursor:pointer;" onclick="deleterow(this)"/></td>';
            mydata += '</tr>';

            $('#tb_grdLabSearchImmuno').append(mydata);
        }

        function deleterow(itemid) {
            var table = document.getElementById('tb_grdLabSearchImmuno');
            table.deleteRow(itemid.parentNode.parentNode.rowIndex);

        }

        function closeme() {
            this.close();
        }



        function getcompletedataadj() {

            var comment = "";
            var objEditor = CKEDITOR.instances['<%=txtcomments.ClientID%>'];
            comment = objEditor.getData();

            var tempData = [];
            $('#tb_grdLabSearchImmuno tr').each(function () {
                if ($(this).attr("id") != "header") {
                    var itemmaster = [];
                    itemmaster[0] = TestID;
                    itemmaster[1] = LabNo;
                    itemmaster[2] = $(this).find("#antiname").html();
                    itemmaster[3] = $(this).find("#antiid").html();
                    itemmaster[4] = $(this).find(".oobbss1").val();
                    itemmaster[5] = $(this).find(".oobbss2").val();
                    itemmaster[6] = $(this).find(".oobbss3").val();
                    itemmaster[7] = $(this).find(".oobbss4").val();
                    itemmaster[8] = $(this).find(".oobbss5").val();
                    itemmaster[9] = $(this).find(".oobbss6").val();
                    itemmaster[10] = $('#txtinter').val();
                    itemmaster[11] = comment;
                    tempData.push(itemmaster);
                }
            });
            return tempData;
        }



        function savedata() {

            if ($('#tb_grdLabSearchImmuno tr').length == "1" || $('#tb_grdLabSearchImmuno tr').length == 0) {
                modelAlert("Please Select Antibodies To Save..!");
                return;
            }


            var mydataadj = getcompletedataadj();

            $.ajax({
                url: "HistoImmunoChemistry.aspx/savedata",
                data: JSON.stringify({ mydataadj: mydataadj }),
                contentType: "application/json; charset=utf-8",
                type: "POST", // data has to be Posted 
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {

                    PanelData = $.parseJSON(result.d);
                    if (PanelData == "1") {
                        modelAlert("Data Saved Successfully..!");

                        // printonly();
                    }
                    else {
                        modelAlert(PanelData);
                    }

                },
                error: function (xhr, status) {
                    modelAlert(xhr.responseText);
                }
            });


        }

        function printonly() {

            if ($('#tb_grdLabSearchImmuno tr').length == "1" || $('#tb_grdLabSearchImmuno tr').length == 0) {
                alert("Please Select Antibodies To Print..!");
                return;
            }
            // this.close();
            window.open("HistoImmunoData.aspx?testid=" + TestID + "&labno=" + LabNo);
        }

        function getdata() {

            $.ajax({
                url: "HistoImmunoChemistry.aspx/getdata",
                data: '{labno:"' + LabNo + '",testid:"' + TestID + '" }', // parameter map 
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {

                    PatientData = $.parseJSON(result.d);
                    var output = $('#tb_PatientLabSearchImmuno').parseTemplate(PatientData);
                    $('#PatientLabSearchOutput').html(output);
                    if (PatientData.length > 0) {
                        $('#txtinter').val(PatientData[0].interpretation);


                    }

                },
                error: function (xhr, status) {
                    $.unblockUI();
                    StatusOFReport = "";
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });


        }

        $(document).ready(function () {
            $('#<% = lstlist.ClientID %>').keydown(function (e) {

                var key = (e.keyCode ? e.keyCode : e.charCode);
                if (key == 13) {
                    e.preventDefault();
                    var index = $('#<% = lstlist.ClientID %>').get(0).selectedIndex;
                    if (index == -1) {
                        alert('Kindly Select an Investigation');
                        return;
                    }

                    addme();

                    //$('#<% = lstlist.ClientID %> option:nth-child(1)').attr('selected', 'selected');


                }

                else if (key == 38 || key == 40) {
                    var index = $('#<% = lstlist.ClientID %>').get(0).selectedIndex;
                    if (key == 38)
                        $('#<% = lstlist.ClientID %> ').attr('selectedIndex', index);
                    else if (key == 40)
                        $('#<% = lstlist.ClientID %> ').attr('selectedIndex', index);


            }



            });
        });



    </script>
<script id="tb_PatientLabSearchImmuno" type="text/html">
    
    
    
        <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_grdLabSearchImmuno" width="99%">
		<tr id="header">
			<th class="GridViewHeaderStyle" scope="col" style="text-align:left"  >S.No</th>
            <th class="GridViewHeaderStyle" scope="col" style="text-align:left"  >IHC Antibody</th>
			<th class="GridViewHeaderStyle" scope="col" style="text-align:left"  >Clone</th>
            <th class="GridViewHeaderStyle" scope="col" style="text-align:left"  >Type</th>
            <th class="GridViewHeaderStyle" scope="col" style="text-align:left"  >Staining Result</th>
              <th class="GridViewHeaderStyle" scope="col" style="text-align:left"  >Intensity</th>
             <th class="GridViewHeaderStyle" scope="col" style="text-align:left"  >Pattern</th>
            <th class="GridViewHeaderStyle" scope="col" style="text-align:left"  >Percentage</th>
			<th class="GridViewHeaderStyle" scope="col" style="text-align:left"  >#</th>
         </tr>



       <#
              var dataLength=PatientData.length;
            
              var objRow;   
        for(var j=0;j<dataLength;j++)
        {

        objRow = PatientData[j];

            #>
<tr style="height:30px;">


<td class="GridViewLabItemStyle"><#=j+1#></td>
<td class="GridViewLabItemStyle" id="antiname"><#=objRow.antiname#></td>
<td class="GridViewLabItemStyle" id="antiid" style="display:none;"><#=objRow.antiid#></td>
<td class="GridViewLabItemStyle" id="clone"><input class="oobbss1" type="text" style="width:80px;" value="<#=objRow.Clone#>" />   </td>
<td class="GridViewLabItemStyle" id="type"><input class="oobbss2" type="text" style="width:80px;" value="<#=objRow.TYPE#>" />   </td>
<td class="GridViewLabItemStyle" id="result"><input class="oobbss3" type="text" style="width:80px;" value="<#=objRow.Result#>" />   </td>
<td class="GridViewLabItemStyle" id="intensity"><input class="oobbss4" type="text" style="width:80px;" value="<#=objRow.Intensity#>" />   </td>
 <td class="GridViewLabItemStyle" id="pattern"><input class="oobbss5" type="text" style="width:80px;" value="<#=objRow.Pattern#>" />   </td>
 <td class="GridViewLabItemStyle" id="percentage"><input class="oobbss6" type="text" style="width:80px;" value="<#=objRow.Percentage#>" />   </td>
<td><img src="../../Images/Delete.gif" style="cursor:pointer;" onclick="deleterow(this)"/></td>
</tr>
         
            

            <#}#>

</table>
           
           
    </script>

