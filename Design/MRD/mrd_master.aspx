<%@ Page Language="C#" AutoEventWireup="true" CodeFile="MRD_Master.aspx.cs" Inherits="Design_MRD_MRD_Master" MasterPageFile="~/DefaultHome.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script type="text/javascript">
        $(document).ready(function () {
            $bindMRDRoom();

        });
        var $MasterType = function (value)
        {
            if (value == "Document") { 
                $('#divDocumentMaster').show();
                $('#divRoomMasterCreate').hide();
                $('#divRackMaster').hide();
                $('#divCreateNewDocument').show();
            
            }
            if (value == "Room") {
               $('#divDocumentMaster').hide();
                $('#divRoomMasterCreate').show();
                $('#divRackMaster').hide();
            }
            if (value == "Rack") { 
                   $('#divDocumentMaster').hide();
                $('#divRoomMasterCreate').hide();
                $('#divRackMaster').show();
                $addNewRack();
                $('#ddlBindMRDRack').attr('disabled', true).chosen("destroy").chosen();
            }

        }



        function checkAllPatientType() {
            var status = $('#<%= chkAllpatientType.ClientID %>').is(':checked');

            if (status == true) {
                $('.chkAllpatienttype input[type=checkbox]').attr("checked", "checked");
            }
            else {
                $(".chkAllpatienttype input[type=checkbox]").attr("checked", false);
            }
        }
        function chkPatienttype() {
            if (($('#<%= chkPatientType.ClientID %>  input[type=checkbox]:checked').length) == ($('#<%=chkPatientType.ClientID %>  input[type=checkbox]').length)) {
                $('#<%= chkAllpatientType.ClientID %>').attr("checked", "checked");
            }
            else {
                $('#<%= chkAllpatientType.ClientID %>').attr("checked", false);
            }
        }
        var saveDocument=function (btnSaveDocument){
            if (validation()) {
                getdocumentdate(function(data){
                    serverCall('MRD_Master.aspx/savedocument', data, function (response) {
                        var responseDate = JSON.parse(response);
                        if (responseDate.Type == "Save") {
                            modelAlert(responseDate.response, function () {
                                Clear();
                            });
                        }
                        else if (responseDate.Type == "Update") {
                            modelAlert(responseDate.response, function () {
                                 $editDocumentMaster();
                            });
                        }
                        else { modelAlert(responseDate.response, function () { }); }
                    
                    });
                });
                }
            else { modelAlert(message) }

        }
        var saveNewRoom = function (btn) {
            if ($('#txtRoomName').val() == "")
            {
                modelAlert('Please Enter Room Name');
                return false;
            }
            var data = {
                roomID: $('#spnRoomID').text().trim(),
                roomName: $('#txtRoomName').val().trim(),
                savetype: $('#btnSaveroom').val(),
                isActive: $('input[type=radio][name=rdoactive]:checked').val(),
            }
            serverCall('MRD_Master.aspx/saveNewRoom', data, function (response) {
                var responseDate = JSON.parse(response);
                modelAlert(responseDate.response, function () {
                    $('#txtRoomName').val('');
                    $('#btnSaveroom').val('Save');
                    $bindMRDRoom();
                })
            });
        }

        var $bindMRDRoom = function () {
            serverCall('MRD_Master.aspx/BindRoom', {}, function (response) {
                Data = JSON.parse(response);
                if (Data != '') {
                    bindMRDRoomDetail(Data);
                }

            });
        }
        function bindMRDRoomDetail(data)
        {
            $('#tbRoomList tbody').empty();
            var row = '';
            for (var i = 0; i < data.length; i++) {
                var j = $('#tbRoomList tbody tr').length + 1;
                row = '<tr>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';
                row += '<td id="tdRoomname" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].NAME + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Active + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Createdby + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + data[i].CreatedDate + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;"><img id="imgEdit" src="../../Images/edit.png" onclick="EditRoomName(this);" style="cursor: pointer;" title="Click To Edit" /></td>';
                row += '<td id="tdActive" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].IsActive + '</td>';
                row += '<td id="tdRoomID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].RMID + '</td>';
                row += '</tr>';
                $('#tbRoomList tbody').append(row);
            }
        }

        var EditRoomName = function (rowID)
        {
            var row = $(rowID).closest('tr');
            $('#txtRoomName').val(row.find('#tdRoomname').text());
            $('#spnRoomID').text(row.find('#tdRoomID').text());
            
            if (row.find('#tdActive').text() == "0") {
                $('input[type=radio][name=rdoactive][value=1]').prop('checked', false);
                $('input[type=radio][name=rdoactive][value=2]').prop('checked', true);
            }
            else {
                $('input[type=radio][name=rdoactive][value=2]').prop('checked', false);
                $('input[type=radio][name=rdoactive][value=1]').prop('checked', true);
            }

            $('#btnSaveroom').val('Update');
        }
                
            var Clear = function () {
                $('#txtDocuement').val('');
                $('#txtSequence').val('');
                $('input[type=checkbox]').prop('checked', false);
                $('#txtRackname').val('');
                $('#txtNoShelf').val('');
                $('#txtMaxFilePerShelf').val('');

            }
            var getdocumentdate = function (callback) {
                var patientType = '';
                    $.each($("input[id*='chkPatientType']:checked"), function () {
                    if (patientType == '')
                        patientType = $(this).val();
                        else
                        patientType = patientType + ',' + $(this).val();
                    });
                var data = {
                    documentName: $('#txtDocuement').val().trim(),
                    sequenceName: $('#txtSequence').val().trim(),
                    patientType: patientType,
                    saveType: $('#btnSave').val(),
                    documentID: $('#spndocumentid').text().trim(),
                    IsActive: $('input[type=radio][name=rdoactive]:checked').val(),

                }
                callback(data);
            }


            var message = '';
            function validation() {
                var count = 0;
                if ($('#txtDocuement').val() == "") {
                    count += 1;
                    message = "Docoument name is required";
                }
                if ($('#txtSequence').val() == "") {
                    count += 1;
                    message = "Sequence No is required";
                }
                if ($('#chkPatientType :checked').length == 0) {
                    count += 1;
                    message = " Kindly select any patient type";
                }
                if (count > 0) {
                    return false;
                }
                return true;
            }
            function validationrack() {
                var count = 0;
                if ($('#txtRackname').val() == "") {
                    count += 1;
                    message = "Rack name is required";
                }
                if ($('#txtNoShelf').val() == "") {
                    count += 1;
                    message = "No Of Shelf  is required";
                }
                if ($('#txtMaxFilePerShelf').val() == "") {
                    count += 1;
                    message = "No Of Maximum per Self   is required";
                }
              
                if (count > 0) {
                    return false;
                }
                return true;
            }
          
            var $adddocumentName = function (el) {
                Clear();
                
                $('#divCreateNewDocument').show();
                $('#divDocumentlist').hide();
                $('#btnSave').val('Save');
                $('#btnSave').show();
            }
            function $editDocumentMaster() {
                $('#divCreateNewDocument').hide ();
                $('#divDocumentlist').show();
                $('#btnSave').hide();
                $bindDocument(function (Document) { });
            }

            $bindDocument = function (callback) {
                var $ddlDocumentName = $('#ddlDocumentName');
                serverCall('MRD_Master.aspx/bindDocumentlist', {}, function (response) {
                    $ddlDocumentName.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'DocumentID', textField: 'NAME', isSearchAble: true });
                    callback($ddlDocumentName.val());
                })
            }
            var $editDocumentlist = function () {
                $('#divCreateNewDocument').show();
                $('#btnSave').show();
                var documentID = $('#ddlDocumentName').val();
                serverCall('MRD_Master.aspx/EditDcouementName', { documentID: documentID }, function (response) {
                    data = JSON.parse(response);
                    if (data != '') {
                        $('#txtDocuement').val(data[0].NAME);
                        $('#txtSequence').val(data[0].SequenceNo);
                        $('#spndocumentid').text(data[0].DocumentID);
                        $('input[type=radio][name=rdDocumentActive][value=' + data[0].Active + ']').prop('checked', true);
                        $('#btnSave').val('Update');
                        var bindpatientType  = data[0].patientType.split(',');
                        $('input:checkbox[id*="chkPatientType"]').attr('checked', false);
                        $('input:checkbox[id*="chkPatientType"]').parent().removeClass('checkbox');
                        for (var i = 0; i < bindpatientType.length; i++) {
                            $('input:checkbox[id*="chkPatientType"]').filter('[value="' + bindpatientType[i] + '"]').attr('checked', true);
                            $('input:checkbox[id*="chkPatientType"]').filter('[value="' + bindpatientType[i] + '"]').parent().addClass('checkbox');
                        }
                      
                    }
                });

            }
        
            var $addNewRack=function(){
                $('#ddlBindMRDRack').attr('disabled', true).chosen("destroy").chosen();
                $('#btnMRDRack').val('Save');
                Clear();
                $bindRackMRDRoom(function(mrdrackroom){});
            }
            var $bindRackMRDRoom = function (callback) {
                var $ddlRackMRDRoom = $('#ddlRackMRDRoom');
                serverCall('MRD_Master.aspx/BindRoom', {}, function (response) {
                    $ddlRackMRDRoom.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'RMID', textField: 'NAME', isSearchAble: true });
                    callback($ddlRackMRDRoom.val());
                });
            }
            var $saveMRDRack = function ()
            {
                if(validationrack())
                    {
                var data = {
                    roomID: $('#ddlRackMRDRoom').val(),
                    rackName: $('#txtRackname').val(),
                    noOfShelf: $('#txtNoShelf').val(),
                    IsActive: $('input[type=radio][name=rdoRackActive]:checked').val(),
                    saveType: $('#btnMRDRack').val(),
                    noOfMaximumfile: $('#txtMaxFilePerShelf').val(),
                    rackID:$('#ddlBindMRDRack').val(),
                }
                serverCall('MRD_Master.aspx/saveNewRack', data, function (response) {
                    var responseDate = JSON.parse(response);
                    modelAlert(responseDate.response, function () {
                        Clear();
                        $('#btnMRDRack').val('Save');
                    });
                });
                    }

                else
                    {
                    modelAlert(message);
                }


            }


       var $showMRDRacklist=function()
       {
           var activeType=$("input[name='MRDRack']:checked").val();
               
              if(activeType!='1')
                  {
           var $ddlBindMRDRack = $('#ddlBindMRDRack');
                serverCall('MRD_Master.aspx/BindMRDRack', {roomID:$('#ddlRackMRDRoom').val()}, function (response) {
                    var responseData= JSON.parse(response);
                    if (responseData.length > 0) {
                        $ddlBindMRDRack.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'AlmID', textField: 'Name', isSearchAble: true });
                        $('#ddlBindMRDRack').removeAttr('disabled').chosen("destroy").chosen();
                    }
                    else {
                        $('#ddlBindMRDRack').attr('disabled', true).chosen("destroy").chosen();
                            modelAlert(" No Rack Found ", function () {
                           
                        });
                    }
                    
                    //callback($ddlBindMRDRack.val());
                });
                  }
          

       }

       var $bindrackdetail = function () {

           if ($('#ddlBindMRDRack').val() == "Select")
           {
               mdoelAlert("Please Select Rack Name");
               return false;
           }
           serverCall('MRD_Master.aspx/bindRackDetail', { RackID: $('#ddlBindMRDRack').val() }, function (response) {
               data = JSON.parse(response)
               if (data != '')
               {
                   $('#txtRackname').val(data[0].Name);
                   $('#txtNoShelf').val(data[0].NoOfShelf);
                   $('#txtMaxFilePerShelf').val(data[0].MaximumNoofFiles);
                   $('input[type=radio][name=rdoRackActive][value=' + data[0].Active + ']').prop('checked', true);
                   $('#btnMRDRack').val('Update');

               }
           });
       }

        var $editRack=function(){
        Clear();
        }

    </script>
 
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
             <b>MRD Master</b>&nbsp;<br />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                MasterType
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlMasterType" onchange="$MasterType(this.value);">
                                <option value="Select">Select</option>
                                <option value="Document">Create Document Master</option>
                                <option value="Room">Create Room Master</option>
                                <option value="Rack">Create Rack Master</option>
                            </select>
                        </div>

                    </div>

                    <div class="col-md-1"></div>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" id="divDocumentMaster" style="display:none">
         <div class="Purchaseheader">
            <input type="radio" id="rdAdddocument" name="Document"  checked="checked" onclick="$adddocumentName(this)" />Add
             <input type="radio" id="rdEditdocument" onclick="$editDocumentMaster(this)" name="Document" />Edit
             
        </div>
            <div class="row" id="divDocumentlist" style="display:none">
                <div class="col-md-3">
                    <label class="pull-left">Document Name</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <select id="ddlDocumentName" onchange="$editDocumentlist(this.value)"></select>
                    <span id="spndocumentid" style="display:none"></span>
                </div>
            </div>
            <div id="divCreateNewDocument" style="display:none">
            <div class="row" >
                <div class="col-md-3">
                    <label class="pull-left">Document</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <input type="text" id="txtDocuement" placeholder=" Docuemnt Name" class="requiredField"/>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Sequence No.</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2">
                    <input type="text" id="txtSequence"  class="requiredField" paceholder="Seq.No"/>
                </div>
                 <div class="col-md-3">
                    <label class="pull-left"><asp:CheckBox ID="chkAllpatientType" ClientIDMode="Static" runat="server" onclick="checkAllPatientType();" Text="Apply On" /></label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:CheckBoxList ID="chkPatientType" runat="server" ClientIDMode="Static"  onclick="chkPatienttype()" RepeatDirection="Horizontal" CssClass="chkAllpatienttype"></asp:CheckBoxList>
                </div>
            </div>
                <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Active</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="radio" name="rdDocumentActive" value="1" checked="checked" />Yes
                            <input type="radio" name="rdDocumentActive" value="0" />No
                        </div>

                </div>
            </div>

            
            
            <div class="row">
                <div class="col-md-24" style="text-align:center">
               <input type="button" id="btnSave" class="ItDoseButton "  value="Save" onclick="saveDocument(this)"/>
                    </div>
            </div>
            </div>    
        <div class="POuter_Box_Inventory" id="divRoomMasterCreate" style="display:none">
         <div class="Purchaseheader">
             <b>Create Room</b>
             <span style="display: none" id="spnRoomID"></span>
        </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                           <label class="pull-left">Room
                           </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" placeholder="Enter Room Name" id="txtRoomName"  class="requiredField"/>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Is Active</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="radio" name="rdoactive" value="1" checked="checked" />Yes
                            <input type="radio" name="rdoactive" value="0" />No
                        </div>
                    
                        <div class="col-md-5">
                            <input  type="button" class="ItDoseButton" id="btnSaveroom" value="Save" onclick="saveNewRoom(this)"/>
                        </div>
                    </div>
                    
                </div>
                <div class="col-md-1"></div>

            </div>
            <div class="row">
                <div id="divList" style="max-height: 400px; overflow-x: auto">
                    <table class="FixedHeader" id="tbRoomList" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse">
                        <thead>
                            <tr>
                                <th class="GridViewHeaderStyle" style="width: 30px;">SrNo</th>
                                <th class="GridViewHeaderStyle" style="width: 150px;">Room Name</th>
                                <th class="GridViewHeaderStyle" style="width: 100px;">Status</th>
                                <th class="GridViewHeaderStyle" style="width: 150px;">Created By</th>
                                <th class="GridViewHeaderStyle" style="width: 150px;">Created Date Time</th>
                                <th class="GridViewHeaderStyle" style="width: 100px;">Edit</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>

        </div>
        <div class="POuter_Box_Inventory" id="divRackMaster" style="display:none">
            <div class="Purchaseheader" style="text-align: left;">
             <b>Rack Master</b>
                  <input type="radio" id="rdRackAdd" name="MRDRack"  checked="checked" onclick="$addNewRack(this)" value="1" />Add New
                 <input type="radio" id="rdRackEdit" onclick="$editRack(this)" name="MRDRack" value="2"/>Edit
        </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">MRD Room</label>
                        <b class="pull-right">:</b>

                    </div>
                    <div class="col-md-5">
                <select id="ddlRackMRDRoom" onchange="$showMRDRacklist(this.value)"></select>
                    <span id="spnRackMRDRoomID" style="display:none" ></span>
                        </div>
                        <div class="col-md-3">
                        <label class="pull-left" id="lblMRDRack" >MRD Rack</label>
                        <b class="pull-right">:</b>

                    </div>
                    <div class="col-md-5">
                <select id="ddlBindMRDRack" onchange="$bindrackdetail(this.value)" ></select>
                    <span id="spnMRDRackid" style="display:none" ></span>
                        </div>
                    </div>
                    </div>
                <div class="col-md-1"></div>
                </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                <div class="row">
                  <div class="col-md-3">
                    <label class="pull-left">Rack Name</label>
                      <b class="pull-right">:</b>
                  </div>
                  <div class="col-md-5">
                    <input type="text" id="txtRackname" class="requiredField" />  
                  </div>  
                    <div class="col-md-3">
                    <label class="pull-left">No. Of Shelf</label>
                      <b class="pull-right">:</b>
                  </div>
                  <div class="col-md-5">
                    <input type="text" id="txtNoShelf" class="requiredField" onlynumber="10" />  
                  </div>  
                     <div class="col-md-5">
                    <label class="pull-left">Maximum No. of Files Per Shelf</label>
                      <b class="pull-right">:</b>
                  </div>
                  <div class="col-md-3">
                    <input type="text" id="txtMaxFilePerShelf"  class="requiredField" onlynumber="10"/>  
                  </div>  
                </div>
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">Is Active</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                            <input type="radio" name="rdoRackActive" value="1" checked="checked" />Yes
                            <input type="radio" name="rdoRackActive" value="0" />No
                        </div>

                </div>
                    </div>
                <div class="col-md-1"></div>

            </div>
             <div class="row">
                 
              <div class="col-md-24" style="text-align:center">
               <input type="button" id="btnMRDRack" class="ItDoseButton "  value="Save" onclick="$saveMRDRack(this)"/>
                </div>
            </div>
            </div>
    </div>
       

</asp:Content>