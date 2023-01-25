<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="SetNoteTypeHeaderMandatory.aspx.cs" Inherits="Design_EMR_SetNoteTypeHeaderMandatory" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">
        var IsEdit = false;
        $(document).ready(function () {
          
           // binHeader(function () { });
            bindNoteType();
            bindNotetypeHeader();
            bindNotetypeHeaderwise();
      
        });
        var binHeader = function (callback) {
          
           

            $ddlheadertype = $('#ddlheadertype');
            serverCall('Services/EMR.asmx/bindNoteTypeHeader', {}, function (response) {
              
                //var data = JSON.parse(response);
                //$("[id$=ddlheadertype]").append('<option selected = "selected" value = "0" >--Select Header Name--</option >');
                //if (data != null && data.length > 0) {
                //    for (var i = 0; i < data.length; i++) {
                //        $("[id$=ddlheadertype]").append('<option value="' + data[i].Header_Id + '">' + data[i].HeaderName + '</option>');
                //    }
                //}
                $ddlheadertype.bindDropDown({ defaultValue: 'All', data: JSON.parse(response), valueField: 'Header_Id', textField: 'HeaderName', isSearchAble: true });
                callback($ddlheadertype.find('option:selected').text());
                
            });
        }

        var ValidateAndSave = function () {
          

            var NoteType = $("[id$=ddlNoteType]").val();

            var HeaderType = $("[id$=ddlheadertype]").val();
            var DepartmentType = $("[id$=ddlNoteType]").val();
            if (NoteType == "0" || DepartmentType == null) {
                modelAlert('Please Select Note Name', function () {
                    $('#ddlNoteType').focus();
                });
                return false;
            }
            if (HeaderType == "0" || HeaderType == null) {
                modelAlert('Please Select Header Type', function () {
                    $('#ddlheadertype').focus();
                });
                return false;
            }
          

            var data = {
                NoteTypeID: $('#ddlNoteType').val(),
                NoteTypeHeaderId: $('#ddlheadertype').val(),
                MendtoryType: $("[id$=ddlMendtoryType]").find('option:selected').val(),
            }



            serverCall('Services/EMR.asmx/SaveNoteTypemandtory', data, function (response) {
                var responseData = JSON.parse(response);
                modelAlert(responseData.response, function () {
                    bindNotetypeHeaderwise();

                   

                });
            });
        }


        function Delete(ctrl) {
          
            serverCall('Services/EMR.asmx/deleteMandtoryType', { Id: ctrl }, function (response) {
                var responseData = JSON.parse(response);
                modelAlert(responseData.response, function () {
                    bindNotetypeHeaderwise();
                });
            });
        }

       
        function bindNoteType() {
            $ddlNoteType = $('#ddlNoteType');
            serverCall('services/EMR.asmx/bindNoteTypeMaster', {}, function (response) {
                $ddlNoteType.bindDropDown({ defaultValue: 'All', data: JSON.parse(response), valueField: 'Header_ID', textField: 'HeaderName', isSearchAble: true });
               // callback($ddlNoteType.find('option:selected').text());
            });
        }
        function bindNotetypeHeaderwise() {
          
            var NoteTypeID = $('#ddlNoteType').val();

            
        serverCall('Services/EMR.asmx/bindNotetypeHeaderwise', { NoteTypeID: NoteTypeID }, function (response) {
                var responseData = JSON.parse(response);
                bindDetails(responseData);
                // Clear();
            });
        }
        function bindDetails(data) {
          
            $('#tbDocumentList tbody').empty();
            var row = '';
            for (var i = 0; i < data.length; i++) {
              
                var j = $('#tbDocumentList tbody tr').length + 1;
                row = '<tr>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';
                row += '<td id="tddocumentname" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].NoteName + '</td>';
                row += '<td id="tdDepartmenttname" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].NoteHeaderName + '</td>';
                row += '<td id="tddescription" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].mandatoryType + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + data[i].CreatedBy + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + data[i].DATETIME + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;"><img id="imgEdit" src="../../Images/Delete.gif" onclick="Delete(' + data[i].Id + ');" style="cursor: pointer;" title="Click To Delete" /></td>';
                row += '<td id="tdAID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].Id + '</td>';
                row += '</tr>';

                $('#tbDocumentList tbody').append(row);
            }
        }
        function Clear() {
            binHeader(function () {

            });
            $("[id$=ddlheader]").val(0);
            bindNotetypeHeaderwise();
        }
       
      
        SearchbyfirstName = function (elem) {
          
            debugger;
            var name = $.trim($(elem).find('option:selected').text());
            if (name != "All") {
                var length = $.trim($(elem).find('option:selected').text()).length;

                $('#tbDocumentList tr').hide();
                $('#tbDocumentList tr:first').show();
                $('#tbDocumentList tr').find('td:eq(1)').filter(function () {
                    debugger;
                    if ($(this).text().substring(0, length).toLowerCase() == name.toLowerCase())
                        return $(this);
                }).parent('tr').show();
            }
            else {
                bindNotetypeHeaderwise();
            }
        }

        function bindNotetypeHeader()
        {
            serverCall('Services/EMR.asmx/bindNoteTypeHeader', {}, function (response) {
                var responseData = JSON.parse(response);
                $ddlheadertype = $('#ddlheadertype');
                $ddlheadertype.bindDropDown({ defaultValue: 'All', data: JSON.parse(response), valueField: 'Header_ID', textField: 'HeaderName', isSearchAble: true });
                
   
            });
        }

        function bindNoteHeaderise() {
            bindNotetypeHeaderwise();
        }

    </script>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Set Note Type Header Mandatory Or Non-Mandatory</b>
            <span style="display: none" id="spnDocumentID"></span>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Enter Details
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">

                         <div class="col-md-3">
                            <label class="pull-left">NoteType</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                                                <asp:DropDownList ID="ddlNoteType"  runat="server" ClientIDMode="Static" CssClass="required" TabIndex="2" ToolTip="Select Note Type" onchange="bindNoteHeaderise()"></asp:DropDownList>
                          
                        </div>

                        <div class="col-md-3">
                            <label class="pull-left">Note Type Header</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                                                <asp:DropDownList ID="ddlheadertype"  runat="server" ClientIDMode="Static" CssClass="required" TabIndex="2" ToolTip="Select Header"></asp:DropDownList>
                          <%--  <asp:DropDownList runat="server" ID="ddlheadertype"></asp:DropDownList>--%>
                        </div>
                         <div class="col-md-3">
                        <label class="pull-left">MandtoryType</label>
                            <b class="pull-right">:</b>
                        </div>
                       <div class="col-md-5">
                           <asp:DropDownList ID="ddlMendtoryType" runat="server" ClientIDMode="Static">
                               <asp:ListItem Value="0">No</asp:ListItem>
                               <asp:ListItem Value="1">Yes</asp:ListItem>
                               
                           </asp:DropDownList>
                       </div>

                    </div>
                   

                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row" style="text-align: center">
                <input type="button" id="btnSave" value="Save" onclick="ValidateAndSave()" />
                <input type="button" id="btnClear" value="Clear" onclick="Clear()" />

            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Header Mandatory Details
            </div>

            <div class="row">
                <div id="divList" style="max-height: 400px; overflow-x: auto">
                    <table class="FixedHeader" id="tbDocumentList" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse">
                        <thead>
                            <tr>
                                <th class="GridViewHeaderStyle" style="width: 30px;">SrNo</th>
                                <th class="GridViewHeaderStyle" style="width: 150px;">Note Type Name</th>
                                <th class="GridViewHeaderStyle" style="width: 150px;">Note Type Header Name</th>
                                <th class="GridViewHeaderStyle" style="width: 150px;">Mandtory Type</th>
                                <th class="GridViewHeaderStyle" style="width: 150px;">Created By</th>
                                <th class="GridViewHeaderStyle" style="width: 150px;">Created Date Time</th>
                                <th class="GridViewHeaderStyle" style="width: 100px;">Delete</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

